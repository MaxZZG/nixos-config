{ pkgs, ... }:
let
  # 壁纸脚本。用 writeShellApplication 包装，把 awww 与 python3 放进 PATH，
  # 这样脚本里可以直接调用 `awww`，手动执行 `wallpaper-rotate` 时也一样。
  wallpaperScript = pkgs.writeShellApplication {
    name = "wallpaper-rotate";
    runtimeInputs = [
      pkgs.awww # 壁纸守护进程客户端（原 swww，v0.12 起改名）
      pkgs.python3 # 脚本解释器
    ];
    text = ''
      exec python3 ${./wallpaper.py}
    '';
  };
in
{
  # awww：Wayland 壁纸守护进程，支持切换时的过渡动画
  # （依赖 wlr-layer-shell，Hyprland 支持；Gnome 不支持）
  home.packages = [
    pkgs.awww
    wallpaperScript # 提供 wallpaper-rotate 命令，可随时手动换一张
  ];

  # ------------------------------------------------------------------
  # 守护进程
  # ------------------------------------------------------------------
  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "awww wallpaper daemon";
      Documentation = "https://codeberg.org/LGFae/awww";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # ------------------------------------------------------------------
  # 换壁纸（单次任务）
  # ------------------------------------------------------------------
  systemd.user.services.wallpaper-rotate = {
    Unit = {
      Description = "Download and apply a random UHD wallpaper";
      # Requires 保证 daemon 先起来；脚本内部也会重试等待其就绪
      After = [ "graphical-session.target" "awww-daemon.service" ];
      Requires = [ "awww-daemon.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${wallpaperScript}/bin/wallpaper-rotate";
      # 脚本行为均可在此调整，无需改 wallpaper.py
      Environment = [
        "WALLPAPER_MARKET=zh-CN" # 区域：zh-CN / en-US / ja-JP ...
        "WALLPAPER_KEEP=20" # 缓存保留张数，超出按时间清理
        "WALLPAPER_TRANSITION=random" # 过渡效果：random/any/simple/center/outer/wipe/left/...
        "WALLPAPER_DURATION=2" # 过渡时长（秒）
      ];
      # 网络不畅时重试，避免一次失败就等到下个周期
      Restart = "on-failure";
      RestartSec = 60;
    };
  };

  # ------------------------------------------------------------------
  # 定时触发
  # ------------------------------------------------------------------
  systemd.user.timers.wallpaper-rotate = {
    Unit = {
      Description = "Rotate wallpaper periodically";
    };
    Timer = {
      OnStartupSec = "2min"; # 登录后 2 分钟换第一张（等桌面就绪）
      OnUnitActiveSec = "1h"; # 之后每小时换一张，想更勤可改 30min
      Unit = "wallpaper-rotate.service";
      Persistent = false; # 关机期间错过的不再补，避免开机瞬间连换数张
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
