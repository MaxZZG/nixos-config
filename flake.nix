{
  description = "Max's nixos configuration";

  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=master&shallow=1";

    home-manager = {
      url = "git+https://git.nju.edu.cn/nix-mirror/home-manager.git?ref=master&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      username = "max";
      system = "x86_64-linux";

      # ---------------------------------------------------------------
      # per-host 自动发现
      # ---------------------------------------------------------------
      # hosts/<主机名>/ 一个目录 = 一台机器，目录名即主机名。
      # 构建某台机器：sudo nixos-rebuild switch --flake .#<主机名>
      #
      # 约定：以 "_" 开头的目录视为模板/草稿，不参与构建。
      # 每个 host 目录需含：
      #   - default.nix                  （导入 hardware-configuration.nix + modules/system + 一个 host-type）
      #   - hardware-configuration.nix   （在该机器上 nixos-generate-config 生成）
      #
      # 注意：flake 只识别 git 跟踪的文件，新增机器目录后记得 `git add hosts/<名>`。
      hostsDir = ./hosts;
      isHost = name: type: type == "directory" && !(nixpkgs.lib.hasPrefix "_" name);
      hostNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs isHost (builtins.readDir hostsDir)
      );

      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs username;
            host = name;
          };
          modules = [ (hostsDir + "/${name}") ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkHost;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
