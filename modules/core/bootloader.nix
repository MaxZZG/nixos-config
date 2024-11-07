{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
