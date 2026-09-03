{ username, ... }:
{
  # Hyprland 系统侧。以下几项 home-manager 做不到，必须由 NixOS 提供：
  #   - security.wrappers.Hyprland：授予 cap_sys_nice（Hyprland 需要给自己设置 SCHED_RR）
  #   - services.displayManager.sessionPackages：注册 desktop session，登录管理器靠它启动
  #   - xdg.portal：启用并注册 xdg-desktop-portal-hyprland（录屏 / 文件选择器）
  #   - environment.systemPackages：安装 hyprland 本体（含 start-hyprland）
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # X11 应用支持（Steam、微信等）
    # 未启用 withUWSM：改用官方推荐的 start-hyprland 启动。
    # 若以后要用 UWSM，需同时把 home.nix 里的 systemd.enable 设为 false（两者冲突）。
  };

  # 登录会话。
  # 用 start-hyprland 而非直接 invoke Hyprland：Hyprland 会检测启动方式，
  # 不经 start-hyprland 启动时会在会话里弹出
  # "Hyprland was started without start-hyprland..." 警告
  # （可用 misc.disable_watchdog_warning 关闭该警告，但正确做法是照它说的用 start-hyprland）。
  #
  # 这里用裸命令走 PATH 解析，是为了让 start-hyprland 内部找到
  # /run/wrappers/bin/Hyprland（带 cap_sys_nice 的 wrapper），而不是 store 里的原始二进制。
  #
  # 注意：greetd 是全局唯一配置，若以后再装别的合成器只能保留一处，
  # 否则 default_session.command 会冲突。
  services.greetd = {
    enable = true;
    settings = {
      # 开机自动登录并直接进入 Hyprland
      initial_session = {
        command = "start-hyprland";
        user = "${username}";
      };
      default_session = {
        command = "start-hyprland";
        user = "${username}";
      };
    };
  };
}
