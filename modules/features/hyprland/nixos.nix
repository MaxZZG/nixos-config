{ pkgs, ... }:
let
  # 包装脚本：强制 Hyprland 加载我们独立的 Lua 配置，并把 kitty 加入 PATH，
  # 避免 exec_cmd("kitty") 因会话 PATH 找不到终端而静默失败。
  hyprlandSession = pkgs.writeShellScript "hyprland-session" ''
    export PATH="${pkgs.kitty}/bin:$PATH"
    export HYPRLAND_CONFIG="$HOME/.config/hypr/config.lua"
    exec ${pkgs.hyprland}/bin/Hyprland "$@"
  '';
in
{
  # hyprland 系统侧：启用程序 + 登录管理器 + 配套包 + portal
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      # 开机自动登录：greetd 直接以 max 身份启动 Hyprland，不弹登录框
      initial_session = {
        command = "${hyprlandSession}/bin/hyprland-session";
        user = "max";
      };
      default_session = {
        command = "${hyprlandSession}/bin/hyprland-session";
        user = "max";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dunst
    waybar
    wofi
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
