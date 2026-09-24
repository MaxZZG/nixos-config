{ ... }:
{
  # 系统侧聚合：基础系统 + 用户/home-manager + 所有功能的系统侧（自动发现）
  imports = [
    ./base.nix
    ./user.nix
    ../features/nixos.nix
  ];
}
