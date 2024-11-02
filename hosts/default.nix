{ inputs, username, host, ... }:
{
  imports = [
    # 硬件配置（必须在目标机器用 nixos-generate-config 生成，见同目录模板）
    ./hardware-configuration.nix
    # 系统侧全部（base + 各功能 nixos 侧，自动发现，无需逐个列出）
    ../modules/system
    # home-manager 集成
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "${host}";

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "wheel" "networkmanager" ];
    # 初始密码：仅当账户当前无密码时生效（不会覆盖已通过 TTY 设置的密码）。
    # 部署后用 `passwd` 修改更安全，避免在配置里明文存密码。
    initialPassword = "max123";
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      imports = [ ../modules/home/default.nix ];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
