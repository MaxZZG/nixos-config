{ pkgs, username, ... }:
{
  # hyprland 系统侧：启用程序 + 登录管理器 + 配套包 + portal
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # 用 start-hyprland + UWSM 启动，走正规 systemd 会话，
    # 避免直接调用 Hyprland 二进制报 “started without start-hyprland”。
    withUWSM = true;
  };

  # 配套包。kitty 放进系统包，确保它位于系统 PATH（/run/current-system/sw/bin），
  # 这样 Hyprland 的 exec_cmd("kitty") 一定能找到。
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
  # 用系统级 sessionVariables 写入 /etc/environment，会话（含 start-hyprland）会继承。
  environment.sessionVariables.HYPRLAND_CONFIG =
    "/home/${username}/.config/hypr/config.lua";

  services.greetd = {
    enable = true;
    settings = {
      # 开机自动登录：通过 start-hyprland 启动（UWSM 会话）。
      # start-hyprland 由 programs.hyprland.withUWSM 提供，位于系统 PATH。
      initial_session = {
        command = "start-hyprland";
        user = "${username}";
      };
      default_session = {
        command = "start-hyprland";
        user = "${username}";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
