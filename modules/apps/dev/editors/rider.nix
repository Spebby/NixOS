{
  my.apps._.editors._.rider.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.rider;

      extraPath = with pkgs; [
        dotnetCorePackages.sdk_8_0
        dotnetPackages.Nuget
        mono
      ];

      extraLib = with pkgs; [
        libx11
        libxcursor
        libxrandr
        libglvnd
        icu
      ];

      riderWrapped = pkgs.jetbrains.rider.overrideAttrs (attrs: {
        postInstall = (attrs.postInstall or "") + ''
          mv $out/bin/rider $out/bin/.rider-unwrapped
          makeWrapper $out/bin/.rider-unwrapped $out/bin/rider \
            --argv0 rider \
            --prefix PATH : "${lib.makeBinPath extraPath}" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLib}"

          shopt -s extglob
          ln -s $out/rider/!(bin) $out/
          shopt -u extglob
        '';
      });
    in
    {
      options.my.apps._.rider.enable =
        lib.mkEnableOption "JetBrains Rider (wrapped for engine integrations)";

      config = lib.mkIf cfg.enable {
        home.packages = [ riderWrapped ];
        xdg.desktopEntries.jetbrains-rider = {
          name = "Rider";
          exec = ''"${riderWrapped}/bin/rider"'';
          icon = "rider";
          terminal = false;
          categories = [
            "Development"
            "IDE"
          ];
        };
      };
    };
}
