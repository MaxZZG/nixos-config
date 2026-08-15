{ pkgs, ... }:
{
  # git 系统侧：仅安装程序
  environment.systemPackages = with pkgs; [
    git
  ];
}
