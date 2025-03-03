{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fastfetch
    vscode

    # DEV
    clang
    cmake
    gnumake
    lldb
  ];
}
