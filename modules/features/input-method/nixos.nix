{ config, pkgs, ... }:
{
  # =============================================================
  # 中州韵（Rime）+ 雾凇拼音（rime-ice）输入法 —— 基于 fcitx5 框架
  # =============================================================
  #
  # 说明：fcitx5-sunpinyin 已从 nixpkgs(master) 移除，故用 Rime 引擎 + 雾凇拼音
  # （rime-ice，长期维护的简体词库，默认即输出简体中文、无需额外禁繁体）。
  #
  # 两个必须遵守的约束（NixOS wiki 明确警告，违反会导致 Rime 显示"使用不可"）：
  #   1. 不要用 environment.systemPackages 装 fcitx5 框架本身。
  #      那会用未打补丁的 fcitx5，addon 检测失效。
  #      正确做法：交给 i18n.inputMethod，它内部用
  #      pkgs.qt6Packages.fcitx5-with-addons.override { addons = ... } 打补丁。
  #   2. 启动 fcitx5 时必须用打过补丁的包（即下面的 config.i18n.inputMethod.package），
  #      不能用 ${pkgs.fcitx5}/bin/fcitx5。
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Rime（中州韵）引擎 + 雾凇拼音（rime-ice）简体词库。
      #   - fcitx5-rime.override { rimeDataPkgs = [ rime-ice ]; } 把雾凇拼音方案注入 Rime。
      #     雾凇默认即输出简体、默认方案就是 rime-ice，无需额外禁繁体。
      #   - 不托管 ~/.local/share/fcitx5/rime：Rime 首次会编译词典到该目录（必须可写），
      #     只读符号链接会让编译失败、输入法失效。
      #   - 暂未启用 librime 的 lua 插件：核心拼音不受影响，仅个别扩展（日期/计算器）不可用。
      addons = with pkgs; [
        (fcitx5-rime.override { rimeDataPkgs = [ rime-ice ]; })
        fcitx5-gtk # GTK 输入法模块，供 XWayland 下的 X11 应用使用
      ];

      # 声明默认输入法组：英文键盘 + Rime（雾凇拼音），默认激活 Rime。
      # 会生成 /etc/xdg/fcitx5/profile；若 ~/.config/fcitx5/profile 已存在则以用户为准。
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

      # 候选窗皮肤：Material Design 风格（仿 Win10 / macOS 输入法，圆角清爽）。
      #   皮肤（主题）由 fcitx5 主配置 config 文件的 [ClassicUI] 段控制，
      #   故写进 settings.globalOptions（自由格式 INI，可放任意段/键），
      #   而不是 settings.addons.classicui（该子模块只接受 globalSection 这类固定键，
      #   放 "ClassicUI" 会报 “unexpected parameter”）。
      #   皮肤包 fcitx5-material-color 提供多套配色，Theme 填对应变体名（区分大小写）：
      #     Material-Color-black / blue / brown / deepPurple / indigo /
      #     orange / pink / red / sakuraPink / teal
      #   其它主题包（需加进下方 environment.systemPackages 并在 Theme 填对应名）：
      #     fcitx5-rose-pine   → rose-pine / rose-pine-dawn / rose-pine-moon
      #     fcitx5-tokyonight  → tokyonight 等；fcitx5-nord → nord；
      #     fcitx5-fluent（Win11 Fluent）、fcitx5-mellow-themes、fcitx5-black-simplicity
      settings.globalOptions."ClassicUI".Theme = "Material-Color-Black";

      # 不设 ignoreUserConfig = true。
      # 该选项会置 SKIP_FCITX_USER_PATH=1，导致用户配置被完全忽略、
      # 用户词典无法保存和加载 —— 对 Rime 而言等于废掉自学习能力。

      # 关键：在 Hyprland / wlroots 这类 Wayland 合成器下，必须启用 Wayland 前端。
      #   - waylandFrontend = true 时，NixOS 不再全局导出 GTK_IM_MODULE / QT_IM_MODULE，
      #     于是 GTK3/GTK4 原生应用（含 Firefox）自动走 text-input-v3 协议，
      #     由合成器（Hyprland）在光标处弹出候选窗。这正解决 Firefox 切了拼音却
      #     看不到候选窗的现象。
      #   - XWayland 下的 X11 应用仍靠全局的 XMODIFIERS=@im=fcitx 走 XIM 输入，不受影响。
      waylandFrontend = true;
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
  # 候选窗皮肤
  # =============================================================
  # fcitx5-material-color（Material Design 风格）主题包，仅提供静态资源，
  # 用 systemPackages 安装无妨（与“别用 systemPackages 装 fcitx5 框架”的约束不冲突）。
  # 具体配色在上方 settings.globalOptions."ClassicUI".Theme 选定（当前 Material-Color-Black）。
  environment.systemPackages = [ pkgs.fcitx5-material-color ];

  # =============================================================
  # 关于用户数据
  # =============================================================
  # Rime（雾凇拼音）的用户词典、编译产物与配置位于 ~/.local/share/fcitx5/rime/。
  #
  # 不托管这些目录/文件：符号链接会让它们变只读，Rime 无法写入词典/编译 build，
  # 输入法会失效。雾凇拼音默认即输出简体中文，无需额外定制。
}
