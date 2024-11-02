{ ... }:
{
  # 系统侧聚合：基础系统 + 所有功能的系统侧（自动发现）
  imports = [
    ./base.nix
    ../features/nixos.nix
  ];
}
