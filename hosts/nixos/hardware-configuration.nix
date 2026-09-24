# =============================================================
# 本机硬件配置（占位）——必须在目标机器上生成后覆盖本文件。
#
# 生成方式（二选一）：
#   1) 已装好系统：
#        sudo nixos-generate-config --show-hardware-config > hosts/<主机名>/hardware-configuration.nix
#   2) 全新安装：
#        nixos-generate-config --root /mnt
#        然后取 /mnt/etc/nixos/hardware-configuration.nix 覆盖本文件
#
# 为什么必须生成：里面包含 fileSystems（按 UUID）等本机唯一信息，
# 若为空或 UUID 不匹配，构建/启动会失败。
# =============================================================
{ ... }:
{
}
