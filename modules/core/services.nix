{ pkgs, ... }:
{
  services = {
    openssh = {
      enable = true;
    };

    greetd = {
      enable = true;
      {
  default_session = {
    command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
  };
}
    };
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
