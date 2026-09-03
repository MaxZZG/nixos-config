{ config, pkgs, ... }:
{
  # =============================================================
  # 中州韵（Rime）输入法 —— 基于 fcitx5 框架
  # =============================================================
  #
  # 两个必须遵守的约束（NixOS wiki 明确警告，违反会导致 Rime 显示"使用不可"）：
  #   1. 不要用 environment.systemPackages 装 fcitx5。
  #      那会用未打补丁的 fcitx5，addon 检测失效。
  #      正确做法：交给 i18n.inputMethod，它内部用
  #      pkgs.qt6Packages.fcitx5-with-addons.override { addons = ... } 打补丁。
  #   2. 启动 fcitx5 时必须用打过补丁的包（即下面的 config.i18n.inputMethod.package），
  #      不能用 ${pkgs.fcitx5}/bin/fcitx5。
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-rime # 中州韵引擎。RIME data 已内置（明月拼音、地球拼音、五笔等）
        fcitx5-gtk # GTK 输入法模块，供 XWayland 下的 X11 应用使用
      ];

      # 声明默认输入法组：英文键盘 + Rime，默认激活 Rime。
      # 会生成 /etc/xdg/fcitx5/profile。
      # 注意：若 ~/.config/fcitx5/profile 存在则以其为准（GUI 改过配置后就是这种情况），
      # 这正是我们不设 ignoreUserConfig 的原因 —— 见下。
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

      # 不设 ignoreUserConfig = true。
      # 该选项会置 SKIP_FCITX_USER_PATH=1，导致用户配置被完全忽略、
      # 用户词典无法保存和加载 —— 对 Rime 而言等于废掉自学习能力。

      # 保持 waylandFrontend = false（默认）：模块会设置
      # GTK_IM_MODULE / QT_IM_MODULE / XMODIFIERS 以及 QT_PLUGIN_PATH。
      # 这样 XWayland 下的 X11 应用（微信、Steam 等）也能用输入法；
      # Wayland 原生应用走 text-input 协议，会忽略这些变量，不受影响。
      #
      # 若只在纯 Wayland 环境且想消除环境变量警告，可改为 true，
      # 代价是 X11 应用将无法输入。
    };
  };

  # =============================================================
  # 自启动
  # =============================================================
  # i18n.inputMethod 模块只装包和写配置，不生成任何自启动项，
  # 因此需要自己提供。
  #
  # 用 systemd 用户服务而非在 hyprland.lua 里 exec-once，原因：
  #   - 崩溃后自动重启
  #   - 能直接引用 config.i18n.inputMethod.package（打过补丁的那个）
  #
  # 它 wantedBy graphical-session.target，而 home-manager 的 hyprland 模块
  # 默认开启 systemd 集成，会拉起 hyprland-session.target → graphical-session.target，
  # 因此进入桌面后 fcitx5 会自动启动。
  systemd.user.services.fcitx5 = {
    description = "Fcitx5 input method framework";
    documentation = [ "man:fcitx5(1)" ];
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${config.i18n.inputMethod.package}/bin/fcitx5";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  # =============================================================
  # 关于用户数据（见 home.nix）
  # =============================================================
  # Rime 的方案与用户词典位于 ~/.local/share/fcitx5/rime/。
  #
  # 不可托管「整个目录」：那会让目录变成只读的 store 符号链接，
  # Rime 无法在其中写入用户词典（*.userdb/）和部署产物（build/），输入法会失效。
  #
  # 但 .custom.yaml 定制档是例外 —— Rime 只读不写，可以安全声明式托管。
  # 默认的简体输出即由此实现，详见 home.nix。
}
