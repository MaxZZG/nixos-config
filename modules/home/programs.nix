{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System Info
    fastfetch

    # Browser
    firefox

    # Hyprland Ecosystem
    waybar
    wofi
    dolphin
    swww
    dunst
    playerctl
    brightnessctl
    hyprpicker
    hyprshot

    # Clipboard
    wl-clipboard

    # DEV
    vscode
    clang
    cmake
    gnumake
    lldb
  ];
}
