{ inputs, pkgs, ... }:
{
  programs.kitty.enable = true; 
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;

    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock
    ];

    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };
}