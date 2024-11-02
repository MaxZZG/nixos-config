{ lib, ... }:
let
  # 自动发现 modules/features/ 下所有子目录，导入各自的 nixos.nix
  # 新增系统级功能：只需建 modules/features/<name>/nixos.nix，无需改任何引用
  dir = ./.;
  featureDirs = lib.filterAttrs (n: t: t == "directory") (builtins.readDir dir);

  # 只导入确实存在 nixos.nix 的目录。
  # 否则空目录（或只建了 home.nix 的纯用户功能）会让 import 指向不存在的文件而报错：
  #   error: getting status of '.../features/<name>/nixos.nix': No such file or directory
  # 这样增删功能目录时不必保证两个入口文件同时在位。
  hasNixos = n: builtins.pathExists (dir + "/${n}/nixos.nix");
  nixosPaths = lib.mapAttrsToList (n: _: dir + "/${n}/nixos.nix") (lib.filterAttrs (n: _: hasNixos n) featureDirs);
in
{
  imports = nixosPaths;
}
