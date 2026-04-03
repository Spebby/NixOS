{
  my.apps._.engines._.godot.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.my.apps._.godot;
    in
    {
      options.my.apps._.godot.enable = lib.mkEnableOption "Enable the Godot game engine";

      config = lib.mkIf cfg.enable {
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
