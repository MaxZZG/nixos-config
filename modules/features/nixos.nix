{ lib, ... }:
let
  # 自动发现 modules/features/ 下所有子目录，导入各自的 nixos.nix
  # 新增系统级功能：只需建 modules/features/<name>/nixos.nix，无需改任何引用
  dir = ./.;
  featureDirs = lib.filterAttrs (n: t: t == "directory") (builtins.readDir dir);
  nixosPaths = lib.mapAttrsToList (n: _: dir + "/${n}/nixos.nix") featureDirs;
in
{
  imports = nixosPaths;
}
