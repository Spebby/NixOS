{
  my.apps._.art._.gimp.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ gimp-with-plugins ];
    };
}
