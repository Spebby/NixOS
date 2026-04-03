{
  my.apps._.productivity.provides =
    { pkgs, ... }:
    {
      writing.homeManager = {
        home.packages = with pkgs; [ zotero ];
      };
    };
}
