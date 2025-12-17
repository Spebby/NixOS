{ inputs, ... }:

{
  nixpkgs.overlays = [
    (
      self: super:
      (
        let
          mypkgs = import inputs.amuletMapEditor {
            inherit (self) system;
            config.allowUnfree = true;
          };

          iconPath = ./amulet_logo-05.png;
        in
        {
          amulet-map-editor = mypkgs.amulet-map-editor.overrideAttrs (oldAttrs: {
            src = super.fetchFromGitHub {
              owner = "Amulet-Team";
              repo = "Amulet-Map-Editor";
              rev = "fix-127";
              hash = "sha256-xEGD3lsXXqzQxrQp+ogdC6qpa7tlvmj5THAZCKRvn2o=";
            };

            postInstall = ''
              mkdir -p $out/share/applications
              cat > $out/share/applications/amulet-map-editor.desktop <<EOF
              [Desktop Entry]
              Name=Amulet Map Editor
              Exec=nvidia-offload amulet_map_editor
              Icon=amulet-map-editor
              Type=Application
              Categories=Game;Utility;
              EOF

              # Install icon from local source
              install -Dm644 ${iconPath} $out/share/icons/hicolor/128x128/apps/amulet-map-editor.png
            '';

          });
        }
      )
    )
  ];
}
