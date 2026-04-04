{ inputs, ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    let
      noctaliaCfg = builtins.fromJSON (builtins.readFile ./noctalia.json);
    in
    {
      packages = lib.optionalAttrs pkgs.stdenv.isLinux {
        myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
          inherit pkgs;
          inherit (noctaliaCfg) settings;
        };
      };
    };
}
