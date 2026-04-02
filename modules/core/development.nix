{ inputs, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ../..;
          excludes = [
            ".*/submodules/.*"
            "^submodules/.*"
          ];

          hooks = {
            flake-checker.enable = true;
            nixfmt = {
              enable = true;
              settings.width = 100;
            };
            statix = {
              enable = true;
              settings.ignore = [ "flake.lock" ];
            };
            deadnix.enable = false;
            nil.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            typos.enable = true;
          };
        };
      };

      devShells.default = pkgs.mkShell {
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    };
}
