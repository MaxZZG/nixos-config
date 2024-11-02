{
  description = "Max's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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
