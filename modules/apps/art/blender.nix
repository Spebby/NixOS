{ inputs, ... }:
{
  my.apps._.art._.blender.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ inputs.blender.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
