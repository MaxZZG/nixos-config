{ ... }:
{
  # neovim 用户侧：设为默认编辑器
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true; # 让 `vim` 命令也调用 neovim
  };
}
