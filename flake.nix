{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager }:
    {
      nixosConfigurations.malmblade = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = nixpkgs.lib.flatten [
          ./hardware-configuration.nix
          (with nixos-hardware.nixosModules; [
            common-pc-laptop
            common-pc-laptop-ssd
            common-cpu-intel
            common-gpu-nvidia
            {
              hardware.nvidia.prime = {
                intelBusId = "PCI:0:2:0";
                nvidiaBusId = "PCI:1:0:0";
              };
              services.xserver.videoDrivers = [ "nvidia" ];
            }
          ])
          home-manager.nixosModules.home-manager
          {
            nix.registry.nixpkgs.flake = nixpkgs;
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
          }
          ./configuration.nix
        ];
      };
    };
}
