{ inputs, pkgs, ... }:
{
  programs = {  
    hyprlock = {
      enable = true;
      extraConfig = builtins.readFile ./hyprlock.conf;
    };
  };
}
