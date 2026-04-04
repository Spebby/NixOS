{
  my.apps._.editors._.vscode.homeManager =
    { pkgs, ... }:
    {
      options.my.apps._.vscode = { };

      config = {
        home.packages = [ pkgs.vscode ];
      };
    };
}
