{
  my.apps._.art._.blender.homeManager =
    { inputs, pkgs, ... }:
    {
      home.packages = [ inputs.blender.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    };
}
