{
  description = "caelestia-shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    caelestia-shell = {
      url = "github:enk-it/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, caelestia-shell, caelestia-cli, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        
        {
          environment.systemPackages = [
            caelestia-shell.packages.x86_64-linux.default
            caelestia-cli.packages.x86_64-linux.default
	    ];
        }
      ];
    };
  };
}

