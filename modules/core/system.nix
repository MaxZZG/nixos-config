{ pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    greetd.tuigreet
  ];

  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

# After 25.05 (Not fully completed and officially released yet)
fonts.packages = with pkgs; [
  nerd-fonts.recursive-mono
];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Recursive" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
