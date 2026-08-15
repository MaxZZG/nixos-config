{ pkgs, ... }:
{
  # neovim 系统侧：安装程序
  environment.systemPackages = with pkgs; [
    neovim
  ];
}
