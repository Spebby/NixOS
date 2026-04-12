{ inputs, ... }:
{
  my.apps._.art._.blender.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.blender ];
    };
}
