# /home-manager/modules/rider.nix
# Credit to huantianad for original configuration.
# https://huantian.dev/blog/unity3d-rider-nixos/

{
  config,
  pkgs-stable,
  lib,
  ...
}:

let
  extra-path = with pkgs-stable; [
    dotnetCorePackages.dotnet_8.sdk
    dotnetCorePackages.sdk_8_0
    dotnetPackages.Nuget
    mono
    msbuild
  ];

  extra-lib = with pkgs-stable; [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    libglvnd
  ];

  cfg = config.rider;
in
{
  options.rider.enable = lib.mkEnableOption "Enable JetBrains Rider";
  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        (pkgs-stable.symlinkJoin {
          name = "rider-wrapped";
          paths = [ pkgs-stable.jetbrains.rider ];
          buildInputs = [ pkgs-stable.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/rider \
              --argv0 rider \
              --prefix PATH : "${lib.makeBinPath extra-path}" \
              --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"
          '';
        })
      ];
      sessionVariables = {
        DOTNET_ROOT = "${pkgs-stable.dotnetCorePackages.dotnet_8.sdk}";
        MSBuildSDKsPath = "${pkgs-stable.dotnetCorePackages.dotnet_8.sdk}/sdk/8.0.100/Sdks"; # adjust version if needed
      };
    };

    # Keep the desktop file
    xdg.dataFile."applications/jetbrains-rider.desktop".text = ''
      [Desktop Entry]
      Name=Rider
      Exec="${pkgs-stable.jetbrains.rider}/bin/rider"
      Icon=rider
      Type=Application
      NoDisplay=true
    '';
  };
}
