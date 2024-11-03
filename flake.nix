{
  description = "Max's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, self, hyprland, ...} @ inputs:
  let
    username = "max";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop
        ];
        specialArgs = { host="desktop"; inherit self inputs username ; };
      };
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          ./hosts/laptop
        ];
        specialArgs = { host="laptop"; inherit self inputs username ; };
      };
    };
  };
}
