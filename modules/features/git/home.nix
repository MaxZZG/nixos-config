{ ... }:
{
  # git 用户侧：用户配置
  programs.git = {
    enable = true;
    settings = {
      user.name = "Max";
      user.email = "zzgdar@163.com";
    };
  };
}
