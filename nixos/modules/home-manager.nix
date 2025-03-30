# /nixos/modules/home-manager.nix

{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager.backupFileExtension = "backup";
}
