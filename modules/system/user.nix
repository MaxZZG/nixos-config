{ inputs, username, ... }:
{
  # home-manager 集成（作为 NixOS 模块引入）
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  # 用户账户：所有机器共用（与硬件无关）
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "wheel" "networkmanager" ];
    # 初始密码：仅当账户当前无密码时生效（不会覆盖已通过 TTY 设置的密码）。
    # 部署后用 `passwd` 修改更安全，避免在配置里明文存密码。
    initialPassword = "max123";
  };

  # home-manager：所有机器共用同一套用户侧配置（modules/home）
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      imports = [ ../home/default.nix ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    };
  };
}
