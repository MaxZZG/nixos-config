{ inputs, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
        name = "Recursive";
        size = 12;
      };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;

    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };
}