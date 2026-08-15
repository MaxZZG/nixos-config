{ lib, ... }:
let
  # 自动发现 modules/features/ 下所有子目录，导入各自的 home.nix
  # 新增用户级功能：只需建 modules/features/<name>/home.nix，无需改任何引用
  dir = ./.;
  featureDirs = lib.filterAttrs (n: t: t == "directory") (builtins.readDir dir);
  homePaths = lib.mapAttrsToList (n: _: dir + "/${n}/home.nix") featureDirs;
in
{
  imports = homePaths;
}
