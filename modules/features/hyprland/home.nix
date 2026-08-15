{ pkgs, ... }:
{
  # hyprland 用户侧：启用窗口管理器 + 会话内 systemd 集成
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };

  # 读取并部署独立的 Lua 配置（同目录 hyprland.lua）。
  # 实际加载由 features/hyprland/nixos.nix 的 wrapper 通过 HYPRLAND_CONFIG 指定。
  home.file.".config/hypr/config.lua" = {
    source = ./hyprland.lua;
  };

  # 安装终端程序（kitty，原生支持 Wayland）
  home.packages = [ pkgs.kitty ];
}
