{
  my.apps._.productivity.provides = {
    writing.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ zotero ];
      };
  };
}
