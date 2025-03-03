{ inputs, pkgs, ... }:
{
  programs = {  
    hyprlock = {
      enable = true;
      extraConfig = builtins.readFile ./hyprlock.conf;
    };
  };

  services.hypridle = {
    enable = true;
    extraConfig = builtins.readFile ./hypridle.conf;
  };

}
