# NOTE: C# does not work properly b/c mono & msbuild conflict on buildEnv.
# consider a better solution. For now, direnv works fine for my purposes.
{ inputs, ... }:
let
  mkLang =
    name:
    let
      packageName = "lang-${name}";
    in
    {
      nixos = { pkgs, ... }: {
        environment.systemPackages = [
          inputs.devshells.packages.${pkgs.stdenv.hostPlatform.system}.${packageName}
        ];
      };

      homeManager = { pkgs, ... }: {
        home.packages = [ inputs.devshells.packages.${pkgs.stdenv.hostPlatform.system}.${packageName} ];
      };
    };

  languages = [
    "c"
    "cpp"
    "rust"
    "zig"
    "csharp"
    "js-ts"
    "python"
    "odin"
    "full"
  ];
in
{
  my.lang.provides = builtins.listToAttrs (
    map (name: {
      inherit name;
      value = mkLang name;
    }) languages
  );
}
