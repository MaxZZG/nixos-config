{ osConfig, lib, pkgs, ... }:
{
  # 仅高性能机器(本机设了 my.highPerformance = true)安装的重型软件,全部走 home-manager。
  # 低配/小盘机不设置该选项(默认 false),此处整块不产生任何包,完全不下载。
  # 以后"吃磁盘/吃性能"的用户态软件(GUI 应用、CLI 工具等)都丢这一行,无需改其它引用;
  # 需要系统级支持(服务/用户组)的才去同目录 nixos.nix。
  home.packages = lib.optionals osConfig.my.highPerformance (with pkgs; [
    moonlight-qt # 远程串流客户端(连 Windows 端的 Sunshine 进行远程工作)
    obs-studio   # 录屏/直播
    qemu         # 虚拟机(含 qemu-system-x86_64 等用户态二进制)
  ]);
}
