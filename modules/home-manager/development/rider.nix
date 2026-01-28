# /home-manager/modules/rider.nix
# Credit to huantianad for original configuration.
# https://huantian.dev/blog/unity3d-rider-nixos/

{
  config,
  lib,
  pkgs-stable,
  ...
}:

let
  cfg = config.rider;

  extraPath = with pkgs-stable; [
    dotnetCorePackages.sdk_8_0
    dotnetPackages.Nuget
    mono
  ];

  extraLib = with pkgs-stable; [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    libglvnd
    icu
  ];

  riderWrapped = pkgs-stable.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = (attrs.postInstall or "") + ''
      # Wrap Rider with required tooling
      mv $out/bin/rider $out/bin/.rider-unwrapped
      makeWrapper $out/bin/.rider-unwrapped $out/bin/rider \
        --argv0 rider \
        --prefix PATH : "${lib.makeBinPath extraPath}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLib}"

      # Unity Rider plugin expects:
      #   <root>/bin/rider
      #   <root>/{lib,plugins,...}
      # It walks up one directory from the binary.
      shopt -s extglob
      ln -s $out/rider/!(bin) $out/
      shopt -u extglob
    '';
  });

in
{
  ###### Options ######
  options.rider = {
    enable = lib.mkEnableOption "JetBrains Rider (wrapped for engine integrations)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ riderWrapped ];
    xdg.desktopEntries.jetbrains-rider = {
      name = "Rider";
      exec = "\"${riderWrapped}/bin/rider\"";
      icon = "rider";
      terminal = false;
      categories = [
        "Development"
        "IDE"
      ];
    };
  };
}
