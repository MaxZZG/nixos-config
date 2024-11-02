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
    { nixpkgs, home-manager, ... }@inputs:
    let
      username = "max";
      system = "x86_64-linux";
      host = "nixos";
    in
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/default.nix
        ];
        # 统一通过 specialArgs 传递参数，避免 extraSpecialArgs 双轨
        specialArgs = {
          inherit inputs username host;
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
