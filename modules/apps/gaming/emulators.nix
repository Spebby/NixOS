{
  my.apps._.emulators.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ rmg ];
    };
}
