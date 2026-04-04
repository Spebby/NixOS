{ lib, config, ... }:
{
  my.apps._.dev.provides.csharp = {
    nixos =
      { pkgs, ... }:
      let
        cfg = config.my.apps._.dev.csharp;
      in
      {
        options.my.apps._.dev.csharp = {
          includeDotnetSdk = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install the .NET SDK for C# development.";
          };

          includeRuntime = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install ASP.NET and .NET runtimes.";
          };

          includeOmnisharp = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install OmniSharp language server tooling.";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Additional C# development packages.";
          };
        };

        config.environment.systemPackages =
          (lib.optionals cfg.includeDotnetSdk [ pkgs.dotnet-sdk_8 ])
          ++ (lib.optionals cfg.includeRuntime [
            pkgs.dotnet-runtime_8
            pkgs.aspnetcore_8_0
          ])
          ++ (lib.optionals cfg.includeOmnisharp [
            pkgs.omnisharp-roslyn
            pkgs.mono
          ])
          ++ cfg.extraPackages;
      };

    homeManager =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.my.apps._.dev.csharp;
      in
      {
        options.my.apps._.dev.csharp.includeCsharpLs = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install csharp-ls language server in the user environment.";
        };

        config.home.packages = lib.optionals cfg.includeCsharpLs [ pkgs.csharp-ls ];
      };
  };
}
