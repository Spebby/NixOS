{
  my.apps._.productivity.provides = {
    writing.homeManager = { pkgs-stable, ... }: { home.packages = with pkgs-stable; [ zotero ]; };
  };
}
