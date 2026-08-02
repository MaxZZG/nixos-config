{
  pkgs,
  inputs,
  ...
}:
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
    # fcitx5 with rime
    fcitx5
    fcitx5-rime
    fcitx5-gtk
    fcitx5-qt
    fcitx5-configtool
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
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-qt
      ];
      fcitx5.waylandFrontend = true;
    };
  };

  # environment variables for fcitx5 in wayland
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    GLFW_IM_MODULE = "ibus";
    SDL_IM_MODULE = "fcitx";
  };

# After 25.05 (Not fully completed and officially released yet)
fonts.packages = with pkgs; [
  nerd-fonts.recursive-mono
  noto-fonts-cjk-serif
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "RecMonoCasual Nerd Font Mono" ];
      serif = [ "Noto Serif CJK SC" ];
      sansSerif = [ "Noto Sans CJK SC" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
