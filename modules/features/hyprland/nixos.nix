{ pkgs, ... }:
{
  # hyprland 系统侧：启用程序 + 登录管理器 + 配套包 + portal
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
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
