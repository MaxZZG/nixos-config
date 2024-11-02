{ pkgs, ... }:
{
  # yazi:终端文件管理器(Rust,vim 风格,飞快)
  # 预览/搜索辅助(均为轻量,不拉桌面环境):
  #   fd / ripgrep  —— 搜索与内容预览
  #   fzf / jq      —— 过滤与 JSON 预览
  #   poppler_utils —— pdftotext / pdftoppm(PDF 文本与图像预览)
  # 说明:图像本身预览走终端的图像协议(Kitty 协议 / Sixel)。
  #   你装了 kitty,在 kitty 里跑 yazi 能直接看图;alacritty 暂不支持图像协议,只能显示占位。
  # 想加视频缩略图可再补 pkgs.ffmpegthumbnailer(会顺带拉 ffmpeg,较重)。
  home.packages = with pkgs; [
    yazi
    fd
    ripgrep
    fzf
    jq
    poppler-utils
  ];
}
