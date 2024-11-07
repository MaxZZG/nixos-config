{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch

    # DEV
    clang
    cmake
    gnumake
    lldb
  ];
}
