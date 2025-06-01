# /home-manager/modules/rider.nix
# Credit to huantianad for original configuration.
# https://huantian.dev/blog/unity3d-rider-nixos/

{ pkgs, lib, ... }:

let
  extra-path = with pkgs; [
    dotnetCorePackages.dotnet_8.sdk
    dotnetCorePackages.sdk_8_0
    dotnetPackages.Nuget
    mono
  ];

  extra-lib = with pkgs; [
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    libglvnd
  ];

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall =
      ''
        # Wrap rider with extra tools and libraries
        mv $out/bin/rider $out/bin/.rider-toolless
        makeWrapper $out/bin/.rider-toolless $out/bin/rider \
          --argv0 rider \
          --prefix PATH : "${lib.makeBinPath extra-path}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"


        # Making Unity Rider plugin work!
        # The plugin expects the binary to be at /rider/bin/rider,
        # with bundled files at /rider/
        # It does this by going up two directories from the binary path
        # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/

        shopt -s extglob
        ln -s $out/rider/!(bin) $out/
        shopt -u extglob
      ''
      + attrs.postInstall or "";
  });
in
{
  home.packages = [ rider ];

  # Hidden desktop file for Unity integration
  xdg.dataFile."applications/jetbrains-rider.desktop".text = ''
    [Desktop Entry]
    Name=Rider
    Exec="${rider}/bin/rider"
    Icon=rider
    Type=Application
    NoDisplay=true
  '';
}
