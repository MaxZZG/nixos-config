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

  # 系统 locale。
  # Chrome 的界面语言直接跟随系统 locale（不像 Firefox 可单独指定），
  # 故想让浏览器显示中文必须设置此项；同时也影响日期格式、排序规则、终端中文显示等。
  i18n.defaultLocale = "zh_CN.UTF-8";

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
