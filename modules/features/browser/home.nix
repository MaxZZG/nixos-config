{ pkgs, ... }:
{
  # =============================================================
  # Firefox —— 用 home-manager 模块管理
  # =============================================================
  programs.firefox = {
    enable = true;

    # 中文语言包。通过 enterprise policy 安装 langpack，
    # Firefox 首次启动时会联网拉取（release 版本号由模块自动推导）。
    # 不需要中文的话删掉这两行即可（删掉 languagePacks 后 intl.locale.requested 也无意义）。
    languagePacks = [ "zh-CN" ];

    profiles.default = {
      # id = 0 即自动成为默认 profile。
      # 注意：模块要求"恰好一个"默认 profile，多设会构建报错。
      id = 0;

      settings = {
        # 界面语言
        "intl.locale.requested" = "zh-CN";

        # ---- 实用设置（不需要可整段删除）----

        # 下载直接保存到 ~/Downloads，不每次弹窗询问
        "browser.download.useDownloadDir" = true;
        "browser.download.folderList" = 1; # 0=桌面 1=下载目录 2=自定义

        # 关闭"推荐扩展/功能"的推荐位，减少干扰
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

        # 保留关闭浏览器时的会话，下次启动恢复
        "browser.startup.page" = 3;

        # 允许扩展在隐私窗口运行（默认关闭）
        "extensions.activePermissionsAndroid" = false;
      };
    };
  };

  # =============================================================
  # Google Chrome —— home-manager 无专用模块，直接装包
  # =============================================================
  # 说明：HM 只有 programs.chromium（给开源 Chromium 的），没有 chrome 模块，
  # 所以 Chrome 走 home.packages。它是 unfree 包，base.nix 已开 allowUnfree。
  #
  # Chrome 相比 Chromium 自带 Widevine，Netflix 等 DRM 站点开箱可播。
  #
  # Wayland：NixOS 下所有 Chromium 系应用靠环境变量 NIXOS_OZONE_WL=1 启用
  # 原生 Wayland，该变量已在 hyprland.lua 中设置，无需额外配置。
  home.packages = with pkgs; [
    google-chrome
  ];

  # =============================================================
  # 默认浏览器（影响 xdg-open 点击链接时用哪个打开）
  # =============================================================
  # 当前设 Firefox。想改成 Chrome，把下面的 "firefox.desktop"
  # 全部换成 "google-chrome.desktop" 即可。
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
}
