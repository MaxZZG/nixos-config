{ ... }:
{
  imports = [
    ./bootloader.nix
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
