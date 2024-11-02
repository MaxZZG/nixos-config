#!/usr/bin/env python3
"""随机壁纸：从 Bing 每日一图下载超高清（4K）壁纸并设置，自动清理缓存。

设计要点：
  1. 优先下载 UHD(4K)，个别图片没有 4K 版本时自动降级到 1920x1080。
  2. 同一天的壁纸只下载一次，之后直接从缓存设置，省流量。
  3. 随机挑选时避开上一次用过的那张，避免连续两次换到同一张。
  4. 每次运行后按修改时间清理，只保留最近 KEEP 张，防止缓存无限增长。

所有行为均可通过环境变量调整（见 home.nix 的 Environment 段）。
"""

from __future__ import annotations

import json
import os
import random
import subprocess
import sys
import time
import urllib.request
from pathlib import Path

# ---------------------------------------------------------------- 配置
BING_HOST = os.environ.get("WALLPAPER_BING_HOST", "https://cn.bing.com")
MARKET = os.environ.get("WALLPAPER_MARKET", "zh-CN")
FETCH_N = int(os.environ.get("WALLPAPER_FETCH_N", "8"))  # 取最近几天（Bing 上限 8）
KEEP = int(os.environ.get("WALLPAPER_KEEP", "20"))  # 缓存保留张数
TRANSITION = os.environ.get("WALLPAPER_TRANSITION", "random")
DURATION = os.environ.get("WALLPAPER_DURATION", "2")

USER_AGENT = (
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)
MIN_SIZE = 10 * 1024  # 小于此值视为错误页，不作为有效图片

cache_home = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
WALLPAPER_DIR = cache_home / "wallpapers"
STATE_FILE = WALLPAPER_DIR / ".last"


def log(msg: str) -> None:
    print(f"[wallpaper] {msg}", flush=True)


def http_get(url: str, timeout: int) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.read()


def fetch_candidates() -> list[dict]:
    """获取最近 FETCH_N 天的壁纸元数据。"""
    api = f"{BING_HOST}/HPImageArchive.aspx?format=js&idx=0&n={FETCH_N}&mkt={MARKET}"
    data = json.loads(http_get(api, timeout=30))
    images = data.get("images") or []
    if not images:
        raise RuntimeError("Bing 返回的图片列表为空")
    return images


def download_one(img: dict) -> Path | None:
    """下载一张壁纸。已存在则复用，UHD 不可用时降级。"""
    urlbase = img.get("urlbase", "")
    startdate = img.get("startdate") or str(int(time.time()))
    if not urlbase:
        return None

    dest = WALLPAPER_DIR / f"bing-{startdate}.jpg"
    if dest.is_file() and dest.stat().st_size > MIN_SIZE:
        return dest  # 已缓存

    for url in (
        f"{BING_HOST}{urlbase}_UHD.jpg",  # 4K 优先
        f"{BING_HOST}{urlbase}_1920x1080.jpg",  # 降级
    ):
        try:
            data = http_get(url, timeout=90)
        except Exception as exc:
            log(f"下载失败（{url}）：{exc}")
            continue
        if len(data) < MIN_SIZE:
            log(f"内容过小，跳过：{url}")
            continue
        tmp = dest.with_suffix(".part")
        tmp.write_bytes(data)
        tmp.replace(dest)  # 原子替换，避免留下半截文件
        log(f"已下载 {dest.name}（{len(data) // 1024} KB）")
        return dest
    return None


def set_wallpaper(path: Path) -> None:
    """调用 awww 设置壁纸。daemon 可能刚启动，故重试若干次。"""
    last_err = ""
    for _ in range(6):
        proc = subprocess.run(
            [
                "awww", "img", str(path),
                "--transition-type", TRANSITION,
                "--transition-duration", DURATION,
                "--transition-fps", "60",
            ],
            capture_output=True,
            text=True,
        )
        if proc.returncode == 0:
            return
        last_err = (proc.stderr or proc.stdout or "").strip()
        log(f"awww 未就绪，2 秒后重试：{last_err}")
        time.sleep(2)
    raise RuntimeError(f"awww 设置壁纸失败：{last_err}")


def pick(images: list[dict]) -> dict:
    """随机挑一张，尽量避开上次用过的那张。"""
    if len(images) == 1:
        return images[0]
    last = STATE_FILE.read_text().strip() if STATE_FILE.is_file() else ""
    others = [i for i in images if (i.get("startdate") or "") != last]
    return random.choice(others or images)


def cleanup() -> None:
    """按修改时间保留最近 KEEP 张，其余删除。"""
    files = sorted(
        WALLPAPER_DIR.glob("bing-*.jpg"),
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    removed = 0
    for p in files[KEEP:]:
        try:
            p.unlink()
            removed += 1
        except OSError:
            pass
    if removed:
        log(f"已清理旧壁纸 {removed} 张（保留最近 {KEEP} 张）")


def main() -> int:
    WALLPAPER_DIR.mkdir(parents=True, exist_ok=True)
    try:
        images = fetch_candidates()
        img = pick(images)
        path = download_one(img)
        if path is None:
            log("所有候选均下载失败")
            return 1
        set_wallpaper(path)
        STATE_FILE.write_text(img.get("startdate", ""))
        log(f"已设置壁纸：{img.get('title') or path.name}")
        cleanup()
        return 0
    except Exception as exc:
        log(f"错误：{exc}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
