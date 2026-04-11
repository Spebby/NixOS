{
  my.lang.provides =
    { self', ... }:
    {
      c = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-c" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-c" ];
        };
      };

      cpp = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-cpp" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-cpp" ];
        };
      };

      rust = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-rust" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-rust" ];
        };
      };

      zig = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-zig" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-zig" ];
        };
      };

      csharp = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-csharp" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-csharp" ];
        };
      };

      js-ts = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-js-ts" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-js-ts" ];
        };
      };

      python = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-python" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-python" ];
        };
      };

      odin = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-odin" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-odin" ];
        };
      };

      full = {
        nixos = {
          environment.systemPackages = [ self'.packages."lang-full" ];
        };
        homeManager = {
          home.packages = [ self'.packages."lang-full" ];
        };
      };
    };
}
