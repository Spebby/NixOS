{
  flake.nixosModules = {
    silent-sddm = import ./default.nix;
    silent-sddm-rosso = import ./rosso.nix;
    silent-sddm-tink = import ./tink.nix;
  };
}
