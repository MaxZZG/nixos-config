{ inputs, pkgs, ... }:
{
  programs.kitty.enable = true;
  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;

    extraConfig = builtins.readFile ./hyprland.conf;

    plugins = [
      #inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    ];

    systemd = {
      enable = true;
      variables = ["--all"];
    };
  };
}