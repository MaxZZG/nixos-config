{ ... }:
{
  # 所有主机共用的基础系统模块
  imports = [
    ../system/bootloader.nix
    ../system/network.nix
    ../system/gc.nix
    ../system/pipewire.nix
    ../system/security.nix
    ../system/services.nix
    ../system/system.nix
    ../system/user-account.nix
  ];
}
