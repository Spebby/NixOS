{ lib, config, ... }:
{
  my.apps._.dev.provides.c.nixos =
    { pkgs, ... }:
    let
      cfg = config.my.apps._.dev;
    in
    {
      options.my.apps._.dev = {
        c = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the C toolchain (clang).";
          };

          includeBuildSystems = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install C-oriented build systems (meson/cmake/make).";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional C-related packages to install.";
          };
        };

        cpp = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the C++ toolchain (gcc).";
          };

          includeBuildSystems = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install C++-oriented build systems (meson/cmake/make).";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional C++-related packages to install.";
          };
        };
      };

      config =
        let
          cBuild = lib.optionals cfg.c.includeBuildSystems [
            pkgs.meson
            pkgs.cmake
            pkgs.gnumake
          ];
          cppBuild = lib.optionals cfg.cpp.includeBuildSystems [
            pkgs.meson
            pkgs.cmake
            pkgs.gnumake
          ];
        in
        {
          environment.systemPackages =
            lib.optionals cfg.c.enable ([ pkgs.clang ] ++ cBuild ++ cfg.c.extraPackages)
            ++ lib.optionals cfg.cpp.enable ([ pkgs.gcc ] ++ cppBuild ++ cfg.cpp.extraPackages);
        };
    };
}
