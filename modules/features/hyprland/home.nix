{ pkgs, ... }:
{
  # hyprland 生态的配套工具（遵循"用户工具走 home-manager"的惯例）
  home.packages = with pkgs; [
    wofi # 应用启动器（SUPER+SPACE）
    hyprlock # 锁屏（SUPER+L）
    brightnessctl # 亮度功能键
    playerctl # 媒体功能键
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # 使用 Lua 配置格式（生成 ~/.config/hypr/hyprland.lua）。
    # 自 Hyprland 0.55 起 hyprlang（.conf）已废弃，upstream 将在后续版本移除支持。
    # 本模块自 stateVersion 26.05 起默认值就是 lua，此处显式写出以防 stateVersion 变动。
    configType = "lua";

    # 置 null 表示复用 NixOS 侧 programs.hyprland 的包，避免两边各编一份
    # （NixOS 侧会对包应用 enableXWayland 覆盖，若 HM 也装一份默认包会产生不同的 store path）。
    # 这是 Hyprland 官方 wiki 对"NixOS 模块 + home-manager 模块"组合的推荐做法。
    package = null;
    portalPackage = null;

    # systemd 集成保持默认开启：会拉起 hyprland-session.target（链接 graphical-session.target），
    # 输入法、通知等会话服务依赖它。
    #
    # 注意：只有在启用 UWSM（programs.hyprland.withUWSM = true）时才需要
    # systemd.enable = false —— 两者会冲突。本配置用 start-hyprland 启动，未用 UWSM，故保持开启。

    # 配置本体写在独立文件，这里只负责读入。
    # 用 extraConfig 注入（而非 xdg.configFile 覆盖）是因为模块自身要写
    # ~/.config/hypr/hyprland.lua，直接覆盖会造成 text/source 冲突。
    extraConfig = builtins.readFile ./hyprland.lua;
  };
}
