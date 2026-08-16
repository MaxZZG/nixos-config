{ pkgs, ... }:
{
  # 读取并部署独立的 Lua 配置（同目录 hyprland.lua）。
  # 实际加载由 features/hyprland/nixos.nix 通过 HYPRLAND_CONFIG 指定。
  # 注意：不要再开启 wayland.windowManager.hyprland.enable，
  # 否则 home-manager 会自行生成配置并可能改写 HYPRLAND_CONFIG，覆盖上面的设定。
  home.file.".config/hypr/config.lua" = {
    source = ./hyprland.lua;
  };

  # 安装终端程序（kitty，原生支持 Wayland）
  home.packages = [ pkgs.kitty ];
}
