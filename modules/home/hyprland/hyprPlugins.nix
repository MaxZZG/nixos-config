{ inputs, pkgs, ... }:
{
  programs = {
    hypridle = {
      enable = true;
      extraConfig = builtins.readFile ./hypridle.conf;
    };
  
    hyprlock = {
      enable = true;
      extraConfig = builtins.readFile ./hyprlock.conf;
    };
  };
}
