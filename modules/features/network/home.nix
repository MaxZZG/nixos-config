{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clash-verge-rev # 代理 GUI 客户端(Clash Meta / mihomo 核心)
  ];
}
