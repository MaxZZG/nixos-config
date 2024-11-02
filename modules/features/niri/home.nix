{ pkgs, ... }:
let
  # 构建期用 `niri validate` 校验 config.kdl:
  # 配置有语法/选项错误会直接让 nixos-rebuild 失败,而不是开机进不去图形界面。
  niriConfig = pkgs.runCommand "niri-config-checked" {
    nativeBuildInputs = [ pkgs.niri ];
  } ''
    niri validate --config ${./config.kdl}
    cp ${./config.kdl} $out
  '';
in
{
  # 把校验通过后的 config.kdl 投递到 ~/.config/niri/config.kdl
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
  ];

  # swaylock 锁屏配置(swaylock-effects):独立文件,软链到 ~/.config/swaylock/config
  # 内容见同目录 swaylock.conf(swaylock 的 option=value 语法,去掉命令行的 --)
  # (./swaylock.conf 是相对本文件所在目录,即 modules/features/niri/swaylock.conf)
  xdg.configFile."swaylock/config".source = ./swaylock.conf;
}
