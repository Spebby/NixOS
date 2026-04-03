{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      noctaliaCfg = builtins.fromJSON (builtins.readFile ./noctalia.json);
    in
    {
      packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        inherit (noctaliaCfg) settings;
      };
    };
}
