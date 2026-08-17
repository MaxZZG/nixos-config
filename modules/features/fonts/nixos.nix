{ pkgs, ... }:
{
  # 字体：
  # - Nerd Font 提供状态栏/终端的图标字形（解决 waybar 图标乱码/豆腐块）
  # - Noto Sans CJK 提供中文渲染（fontconfig 会自动按字形回退到对应字体）
  fonts.packages = with pkgs; [
    nerd-fonts.recursive-mono
    noto-fonts-cjk-sans
  ];
  fonts.fontconfig.enable = true;
}
