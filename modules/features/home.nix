{ lib, ... }:
let
  # 自动发现 modules/features/ 下所有子目录，导入各自的 home.nix
  # 新增用户级功能：只需建 modules/features/<name>/home.nix，无需改任何引用
  dir = ./.;
  featureDirs = lib.filterAttrs (n: t: t == "directory") (builtins.readDir dir);

  # 只导入确实存在 home.nix 的目录（理由同 nixos.nix：避免空目录导致 import 失败）
  hasHome = n: builtins.pathExists (dir + "/${n}/home.nix");
  homePaths = lib.mapAttrsToList (n: _: dir + "/${n}/home.nix") (lib.filterAttrs (n: _: hasHome n) featureDirs);
in
{
  imports = homePaths;
}
