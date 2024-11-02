{ ... }:
{
  imports = [
    ./bootloader.nix
    ./hardware.nix
    ./network.nix
    ./gc.nix
    ./pipewire.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./user.nix
    ./wayland.nix
  ];
}
