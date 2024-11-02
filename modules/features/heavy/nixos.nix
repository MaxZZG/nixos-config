{ config, lib, username, ... }:
{
  # 仅高性能机器开启的系统级支持(需要 root/服务/用户组的部分;纯用户态软件在 ./home.nix)。
  # 低配/小盘机不设置 my.highPerformance(默认 false),整块被丢弃,不引入任何系统服务。
  # 注意:NixOS 模块读配置用 config 参数;osConfig 是 home-manager 模块专属,这里没有。
  config = lib.mkIf config.my.highPerformance {
    # qemu/KVM 虚拟机系统侧:libvirtd 守护进程
    virtualisation.libvirtd.enable = true;

    # 让本机用户能直接用 /dev/kvm 与 libvirt,无需每条命令 sudo。
    # extraGroups 为 list 类型,会与 user.nix 里的 [ wheel networkmanager ] 自动合并。
    users.users.${username}.extraGroups = [ "kvm" "libvirtd" ];
  };
}
