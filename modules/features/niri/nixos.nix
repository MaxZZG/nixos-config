{ pkgs, username, config, ... }:
{
  # =============================================================
  # niri —— 滚动平铺 Wayland 合成器(nixpkgs 原生模块,无需 niri-flake)
  # =============================================================
  # enable = true 会自动:安装 niri、注册显示管理器会话、配置
  # xdg-desktop-portal / gnome-keyring,并已自动设
  # systemd.user.services.niri.enableDefaultPath = false。
  programs.niri.enable = true;

  # greetd:开机自动登录 niri
  # ⚠️ 坑:NixOS 的 greetd 模块会强制写入 [default_session] user="greeter",
  #    但没有 command;greetd 要求 default_session.command 必填,
  #    缺了就会启动失败 —— 症状正是「reached target Graphical Interface 后卡死」。
  #    所以必须补上 default_session.command。
  services.greetd = {
    enable = true;
    # tuigreet 是文本界面 greeter,配合此项调整 TTY,免受开机日志干扰
    useTextGreeter = true;
    settings = {
      # 正常登录界面(注销后回到这里);登录后由它拉起 niri-session
      default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${config.programs.niri.package}/bin/niri-session";
      # 首次启动直接顶替 greeter,以 username 身份自动登录进 niri
      initial_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = username;
      };
    };
  };

  # niri 模块默认不启用 XWayland;装 xwayland-satellite 后开箱即用地支持 X11 应用。
  environment.systemPackages = [ pkgs.xwayland-satellite ];
}
