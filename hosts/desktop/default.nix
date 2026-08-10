{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/base.nix
    ../../modules/profiles/desktop.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";
}
