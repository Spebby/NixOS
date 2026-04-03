{
  perSystem =
    { pkgs, ... }:
    let
      dconf2nixExport = pkgs.writeShellApplication {
        name = "dconf2nix-export";
        runtimeInputs = with pkgs; [
          dconf
          dconf2nix
        ];
        text = ''
          cat <<'EOF'
          dconf2nix export stub

          This command is a placeholder and is not implemented yet.

          Planned behavior:
          - export selected dconf paths
          - convert to Nix/home-manager friendly output
          - write to a target file in this repository

          Example future usage:
          nix run .#dconf2nix-export -- --path /org/gnome/ --output modules/desktops/gnome/dconf.nix
          EOF
        '';
      };
    in
    {
      packages.dconf2nix-export = dconf2nixExport;

      apps.dconf2nix-export = {
        type = "app";
        program = "${dconf2nixExport}/bin/dconf2nix-export";
      };

      devShells.dconf2nix-export = pkgs.mkShell {
        packages = with pkgs; [
          dconf
          dconf-editor
          dconf2nix
        ];
      };
    };
}
