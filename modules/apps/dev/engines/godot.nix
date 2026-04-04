{
  my.apps._.engines._.godot.homeManager =
    { pkgs, ... }:
    {
      options.my.apps._.godot = { };

      config = {
        home = {
          packages = with pkgs; [
            godot-mono
            godot-export-templates-bin
            godotPackages.export-templates-mono-bin
            dotnetCorePackages.dotnet_8.sdk
          ];

          file.".local/share/godot/export_templates/4.6.stable.mono".source =
            pkgs.godotPackages.export-templates-mono-bin.out + "/share/godot/export_templates/4.6.stable.mono";
        };
      };
    };
}
