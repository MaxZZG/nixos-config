{ inputs, pkgs, ... }:
{
  imports = [
    # 系统侧全部(base + 各功能 nixos 侧,自动发现,无需逐个列出)
    ../../modules/system
    # 本机硬件配置(在 MateBook E 上安装时由 nixos-generate-config 生成,见同目录)
    ./hardware-configuration.nix
    # home-manager 集成
    inputs.home-manager.nixosModules.home-manager
  ];

  # =====================================================================
  # 华为 MateBook E 2017 专属硬件配置
  # 机型 = Intel Kaby Lake(m3-7Y30 / i5-7Y54)的 12" 可拆卸 2-in-1,
  # 2160x1440 3:2 触控屏 + 可拆键盘坞。键盘坞无独立音量/亮度键,
  # 已在 niri 里用 Mod+Alt+方向键 兜底(见 modules/features/niri/config.kdl)。
  # =====================================================================

  # --- 固件:Intel WiFi / 蓝牙 / 核显微码等(开源可再分发固件)---
  hardware.enableRedistributableFirmware = true;

  # --- Intel 核显(HD Graphics 615 / i915)---
  hardware.graphics = {
    enable = true;
    # Kaby Lake 的 VA-API 硬解
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # --- 平板 / 触控:传感器代理(重力 + 陀螺,供自动旋转读取)---
  # 注意:niri 本身不自动旋转,此代理只把传感器暴露到 D-Bus;
  # 想自动旋转需另跑 monitor-sensor 脚本或屏幕旋转工具。
  hardware.sensor.iio.enable = true;

  # --- 省电(2-in-1 电池设备)---
  powerManagement.cpuFreqGovernor = "powersave";
  services.tlp.enable = true;

  # --- 触控屏 / 触控笔:libinput 随 niri 原生工作,无需额外配置 ---
  # (拆掉键盘坞进入平板模式时,可启用下面的虚拟键盘)
  # environment.systemPackages = [ pkgs.squeekboard ];

  # --- 音频(Kaby Lake 板载声卡)---
  # 若装好后扬声器/麦克风无声,多为 SOF/SST 驱动之争,
  # 取消下一行注释强制走 SST 旧驱动通常即可恢复:
  # boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];

  # --- 指纹(Goodix):当前主线内核无可用驱动,跳过 ---
}
