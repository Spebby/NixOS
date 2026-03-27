{
  flake.nixosModules.host-common = {
    imports = [
      ./boot.nix
      ./environment.nix
      ./hardware.nix
      ./locale.nix
      ./networking.nix
      ./nix-config.nix
      ./programs.nix
      ./security.nix
      ./services.nix
    ];
  };
}
