# =============================================================
# 本机 host：<在此写机型/型号备注，例如 AMD 740M + RTX 3050 笔记本>
# 目录名 = 主机名（构建：sudo nixos-rebuild switch --flake .#nixos）
# =============================================================
{ ... }:
{
  imports = [
    # 1) 本机硬件（在该机器上生成后覆盖本文件，见同目录模板/注释）
    ./hardware-configuration.nix
    # 2) 系统 + home-manager + 所有功能（共享）
    ../../modules/system
    # 3) 机型共享配置：从 laptop / desktop / minipc / convertible 里选一个
    ../../modules/host-types/laptop.nix
  ];

  # -------------------------------------------------------------
  # 以下是「本机专属」内容，共享模块里不该出现的都写这里：
  #   - 内核参数   boot.kernelParams = [ "acpi_backlight=native" ];
  #   - 显卡驱动   hardware.nvidia.*
  #   - niri 输出  output "eDP-1" { scale 1.4; }（见 modules/features/niri/config.kdl）
  # -------------------------------------------------------------
}
