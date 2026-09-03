{ config, pkgs, ... }:
{
  # 如果需要重新部署rime-ice，需要删掉 .local/.../rime 文件夹 
  home.file.".local/share/fcitx5/rime/default.custom.yaml".text = ''
    patch:
      __include: rime_ice_suggestion:/
  '';
}
