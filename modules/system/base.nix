{ pkgs, ... }:
{
  # 启用 flakes 与 nix-command
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
}
