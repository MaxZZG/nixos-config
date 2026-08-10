{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/profiles/base.nix
    ../../modules/profiles/laptop.nix
  ];
}
