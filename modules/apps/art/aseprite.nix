{
  my.apps._.art._.aseprite.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ aseprite ];
    };
}
