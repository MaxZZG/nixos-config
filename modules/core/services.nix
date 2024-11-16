{ config, pkgs, username, ... }:
{
  services = {
    openssh = {
      enable = true;
    };

    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "Hyprland";
        };
      };
    };
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
