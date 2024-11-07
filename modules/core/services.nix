{ ... }:
{
  services = {
    openssh = {
      enable = true;
    };
  };
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
