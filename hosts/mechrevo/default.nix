# =============================================================
# 本机 host：<在此写机型/型号备注,例如 AMD 740M + RTX 3050 笔记本>
# 目录名 = 主机名(构建：sudo nixos-rebuild switch --flake .#mechrevo)
# =============================================================
{ pkgs, ... }:
{
  imports = [
    # 1) 本机硬件(在该机器上生成后覆盖本文件,见同目录模板/注释)
    ./hardware-configuration.nix
    # 2) 系统 + home-manager + 所有功能(共享)
    ../../modules/system
    # 3) 机型共享配置：从 laptop / desktop / minipc / convertible 里选一个
    ../../modules/host-types/laptop.nix
  ];

  # 本机专属 niri 配置：追加到 ~/.config/niri/config.kdl 末尾(output / cursor 等因机而异的设置)
  my.niri.extraConfig = ''
    output "eDP-1" {
        scale 1.4
        hot-corners {
            off
        }
    }

    output "eDP-2" {
        scale 1.4
        hot-corners {
            off
        }
    }
  '';

  # ===================== Nvidia RTX3050 PRIME Offload 核心 =====================
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # 空闲自动关闭独显,省电

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # 生成 nvidia-offload 包装命令
      };
      # 这里改成你 lspci 查到的真实PCI ID！
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    nvidiaSettings = true; # 带 nvidia-settings 工具
    # package = config.boot.kernelPackages.nvidiaPackages.unstable; # 驱动版本不够时打开
  };

  # Xorg 配置(如果你用X11;Wayland 不需要这行,但写上无害)
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
  
  # 可选：nouveau自动黑名单,nvidia模块会自动处理,这里兜底
  boot.blacklistedKernelModules = [ "nouveau" ];

  # 可选：添加配套工具包
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver # Nvidia硬解视频
    # CUDA 工具链:版本随 nixpkgs 渠道,与 hardware.nvidia 驱动自动匹配
    cudaPackages.cudatoolkit # nvcc + libcudart/cublas 等运行时
    cudaPackages.cudnn # 深度学习常用(可选)
    moonlight-qt # 远程串流客户端(连 Windows 端的 Sunshine 进行远程工作)
  ];

  # 让非 nix 构建的 CUDA 程序(如 pip 装的 torch)也能找到 libcuda
  programs.nix-ld.enable = true;

  # 合盖不挂起:只熄屏,绝不 sleep(规避独显直连/部分机型 s2idle 唤醒黑屏)
  # 若要恢复合盖睡眠,把这段删掉即可
  # 这段必须开启 dGPU-only, 不然可能会有问题
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
