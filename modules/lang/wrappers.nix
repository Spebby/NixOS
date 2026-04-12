{
  my.lang.provides =
    { inputs, pkgs, ... }:
    let
      langPkgs = inputs.devshells.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      c = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-c" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-c" ];
        };
      };

      cpp = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-cpp" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-cpp" ];
        };
      };

      rust = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-rust" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-rust" ];
        };
      };

      zig = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-zig" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-zig" ];
        };
      };

      csharp = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-csharp" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-csharp" ];
        };
      };

      js-ts = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-js-ts" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-js-ts" ];
        };
      };

      python = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-python" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-python" ];
        };
      };

      odin = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-odin" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-odin" ];
        };
      };

      full = {
        nixos = {
          environment.systemPackages = [ langPkgs."lang-full" ];
        };
        homeManager = {
          home.packages = [ langPkgs."lang-full" ];
        };
      };
    };
}
