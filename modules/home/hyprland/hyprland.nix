{ inputs, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "RecMonoCasual Nerd Font Mono";
      size = 14;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };
}
