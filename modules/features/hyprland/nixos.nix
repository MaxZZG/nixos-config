{ pkgs, username, ... }:
{
  # hyprland 系统侧：启用程序 + 登录管理器 + 配套包 + portal
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 配套包。kitty 放进系统包，确保它位于系统 PATH（/run/current-system/sw/bin），
  # 这样 Hyprland 的 exec_cmd("kitty") 一定能找到，不依赖 home-manager profile 的 PATH。
  environment.systemPackages = with pkgs; [
    kitty
    dunst
    waybar
    wofi
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
  ];

  # 强制 Hyprland 加载我们独立的 Lua 配置（~/.config/hypr/config.lua），
  # 而不是默认的 hyprland.lua（被 home-manager 写坏过）。
  # 用系统级 sessionVariables 写入 /etc/environment，greetd 经 PAM 会带进会话。
  environment.sessionVariables.HYPRLAND_CONFIG =
    "/home/${username}/.config/hypr/config.lua";

  services.greetd = {
    enable = true;
    settings = {
      # 开机自动登录：greetd 直接以 max 身份启动 Hyprland，不弹登录框。
      # command 必须是直接可执行的绝对路径，不能套 wrapper 脚本。
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${username}";
      };
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "${username}";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
