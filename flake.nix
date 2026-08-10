{
  description = "Max's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.11";

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rime-wanxiang = {
      url = "github:amzxyz/RIME-wanxiang";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      self,
      hyprland,
      ...
    }@inputs:
    let
      username = "max";
      system = "x86_64-linux";
      # 统一通过 specialArgs 传递所有参数，消除 extraSpecialArgs 双轨
      inherit inputs username;
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/desktop
          ];
          specialArgs = {
            host = "desktop";
            inherit inputs username;
          };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/laptop
          ];
          specialArgs = {
            host = "laptop";
            inherit inputs username;
          };
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
