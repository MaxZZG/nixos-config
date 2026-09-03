{ config, pkgs, ... }:
{
  # =============================================================
  # fcitx5 + Rime（中州韵）+ 雾凇拼音（rime-ice，简体词库）
  # =============================================================
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Rime 引擎 + 雾凇拼音。rime-ice 只提供方案数据，必须搭配 fcitx5-rime。
      addons = with pkgs; [
        (fcitx5-rime.override { rimeDataPkgs = [ rime-ice ]; })
        fcitx5-gtk # XWayland 下的 X11 应用
      ];

      # wlroots / Hyprland 下必须启用 Wayland 前端，原生应用才能弹候选窗。
      waylandFrontend = true;

      # 输入法组：英文键盘 + Rime，默认激活 Rime。
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "rime";
      };
    };
  };

  # 自启动：用打过补丁的 fcitx5 包，进入图形会话后自动拉起。
  systemd.user.services.fcitx5 = {
    description = "Fcitx5 input method framework";
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
