{ ... }:
{
  # =============================================================
  # Rime 定制档（声明式）
  # =============================================================
  # 只托管两个 *.custom.yaml，不托管整个 ~/.local/share/fcitx5/rime/ 目录。
  #
  # 为什么这样是安全的：
  #   - .custom.yaml 是 Rime 设计给用户写的定制档，Rime 只读不写，
  #     符号链接不影响它；升级时也不会被覆写。
  #   - 用户词典（*.userdb/）、部署产物（build/）是独立的文件/目录，
  #     它们仍由 Rime 写入，不受这两个链接影响。
  #
  # 反之，若托管整个 rime 目录，目录本身会变成只读的 store 符号链接，
  # Rime 无法在其中创建用户词典和 build/，输入法会直接失效。
  #
  # 内容见同目录的 default.custom.yaml 与 luna_pinyin.custom.yaml。
  home.file.".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
  home.file.".local/share/fcitx5/rime/luna_pinyin.custom.yaml".source = ./luna_pinyin.custom.yaml;
}
