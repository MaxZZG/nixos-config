{ pkgs, lib, ... }:
{
  # 启用 flakes 与 nix-command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = lib.mkForce [
        "https://mirrors.nju.edu.cn/nix-channels/store"
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # 网络
  networking.networkmanager.enable = true;

  # 时区与 locale
  time.timeZone = "Asia/Shanghai";

  # 最新内核
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 启动加载器（EFI + systemd-boot）
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 音频
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # 蓝牙
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    bluetui
  ];
}
