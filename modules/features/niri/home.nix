{ pkgs, osConfig, ... }:
let
  # 本机专属 niri 配置：由各 host 的 default.nix 通过 my.niri.extraConfig 提供,
  # 这里经 osConfig 读取(home-manager 用户模块里访问系统配置的标准桥),拼到共享 config.kdl 末尾。
  # 新增机器：只需在自己的 host 文件里设 my.niri.extraConfig,共享模块无需改动。
  hostOutputs = pkgs.writeText "niri-host-extra.kdl" (osConfig.my.niri.extraConfig or "");

  # 构建期用 `niri validate` 校验拼接后的完整配置:
  # 配置有语法/选项错误会直接让 nixos-rebuild 失败,而不是开机进不去图形界面。
  niriConfig = pkgs.runCommand "niri-config-checked" {
    nativeBuildInputs = [ pkgs.niri ];
  } ''
    cat ${./config.kdl} ${hostOutputs} > $out
    niri validate --config $out
  '';
in
{
  # 把校验通过后的 config.kdl(共享主体 + 本机 output 段)投递到 ~/.config/niri/config.kdl
  # (./config.kdl 是相对本文件所在目录,即 modules/features/niri/config.kdl)
  xdg.configFile."niri/config.kdl".source = niriConfig;

  # niri 会 spawn 的程序
  # - wofi:应用启动器(Super+D)
  # - playerctl / brightnessctl:媒体键、亮度键(swayosd 也靠 brightnessctl 读背光)
  # - swayosd:音量 / 亮度浮动 OSD(swayosd-server 常驻 + swayosd-client 触发)
  # - swaylock-effects:锁屏(Super+Alt+L),带时钟 + 模糊背景;主程序名仍是 swaylock
  home.packages = with pkgs; [
    wofi
    playerctl
    brightnessctl
    swayosd
    swaylock-effects
    bibata-cursors
    libnotify # 提供 notify-send,可手动发通知(状态热键等)
    # 状态浮层:Mod+Alt+T 触发,脚本源文件见同目录 status-osd(可单独编辑,改完 rebuild 即可)
    (writeShellScriptBin "status-osd" (builtins.readFile ./status-osd))
  ];

  # swaylock 锁屏配置(swaylock-effects):独立文件,软链到 ~/.config/swaylock/config
  # 内容见同目录 swaylock.conf(swaylock 的 option=value 语法,去掉命令行的 --)
  # (./swaylock.conf 是相对本文件所在目录,即 modules/features/niri/swaylock.conf)
  xdg.configFile."swaylock/config".source = ./swaylock.conf;

  # 通知守护:注册 org.freedesktop.Notifications,首个通知到达时自动拉起(无需状态栏)
  services.swaync = {
    enable = true;
    settings = {
      position = "top-right"; # 通知出现在右上角
      timeout = 5;            # 5 秒后自动消失
    };
  };
}
