{ pkgs, lib, host, ... }:
{
  # 自定义 option：本机专属的 niri 额外配置(因机而异的 output / cursor 等)。
  # 由各 host 的 default.nix 设置,home-manager 的 niri 模块经 osConfig 读取并拼到 config.kdl 末尾。
  # 注意：模块顶层一旦出现 options,所有配置项都必须包在 config = { } 里。
  options.my.niri.extraConfig = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "追加到本机 niri config.kdl 末尾的内容(output / cursor 等因机而异的设置)。";
  };

  config = {
    # 主机名 = hosts/ 下的目录名(flake 通过 specialArgs.host 传入)
    networking.hostName = host;

    # 系统状态版本：与安装时机绑定,确定后不要再改
    system.stateVersion = "26.05";

    # Wayland / OpenGL 图形栈(所有机器都需要)
    hardware.graphics.enable = true;

    # 启用 flakes 与 nix-command
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        # 清华镜像(国内最快、完整同步 cache.nixos.org)优先,官方源兜底
        substituters = [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          "https://cache.nixos.org"
        ];
      };
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 1d";
      };
    };

    nixpkgs.config.allowUnfree = true;

    # 网络
    networking.networkmanager.enable = true;

    # SSH
    services.openssh = {
      enable = true;
      openFirewall = true;            # 放行 22 端口(NixOS 防火墙默认开启)
      settings = {
        PasswordAuthentication = true;  # 首次用密码登录(Windows PuTTY / OpenSSH);配好密钥后建议改 false
        PermitRootLogin = "no";         # 禁止 root 直接登录,用 max 账户 + sudo
      };
    };

    # 时区与 locale
    time.timeZone = "Asia/Shanghai";

    # 内核
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # 系统 locale。
    # Chrome 的界面语言直接跟随系统 locale(不像 Firefox 可单独指定),
    # 故想让浏览器显示中文必须设置此项;同时也影响日期格式、排序规则、终端中文显示等。
    i18n.defaultLocale = "zh_CN.UTF-8";

    # 启动加载器(EFI + systemd-boot)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # 音频
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # 蓝牙
    hardware.bluetooth.enable = true;
    environment.systemPackages = with pkgs; [
      bluetui
      pciutils
    ];
  };
}
