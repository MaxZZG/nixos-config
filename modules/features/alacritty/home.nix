{ ... }:
{
  # alacritty 是纯用户程序,安装与配置由 home-manager 的 programs.alacritty 管理,
  # 系统侧无需安装。
  programs.alacritty = {
    enable = true;
  };

  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;
}
