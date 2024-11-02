{ pkgs, ... }:
{
  # =============================================================
  # 机型共享配置：台式机
  # =============================================================
  # 台式机没有电池；外接显示器亮度不走背光接口，需用 DDC/CI(ddcutil)。

  # ddcutil 通过 i2c 调节外接显示器亮度
  boot.kernelModules = [ "i2c-dev" ];
  environment.systemPackages = [ pkgs.ddcutil ];
  # 用法：ddcutil --display 1 setvcp 10 + 10   （取决于显示器编号/能力）

  # 提示：可用的独显驱动(如 hardware.nvidia)按机器写在各 host 里。
}
