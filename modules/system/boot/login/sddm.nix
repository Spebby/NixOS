{ inputs, ... }:
{
  my.login.provides.sddm.nixos =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.login.sddm;
      hasTheme = cfg.theme.package != null;
      activeTheme =
        if hasTheme then
          cfg.theme.package
        else
          inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
            inherit (cfg) preset extraBackgrounds;
            theme-overrides = cfg.themeOverrides;
          };
    in
    {
      options.my.login.sddm = {
        enable = lib.mkEnableOption "Enable SDDM login manager";

        wayland = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable SDDM Wayland mode.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.kdePackages.sddm;
          description = "SDDM package to use.";
        };

        includeThemePackage = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install active SDDM theme package in systemPackages for inspection/testing.";
        };

        theme = {
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Optional prebuilt theme package. If null, the silentSDDM package is built from options below.";
          };

          name = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Optional explicit SDDM theme name. Null uses activeTheme.pname.";
          };

          extraPackages = lib.mkOption {
            type = lib.types.listOf lib.types.package;
            default = [ ];
            description = "Extra SDDM runtime packages (QML imports/assets).";
          };

          includeTestPackage = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Install theme test package (if provided by the active theme).";
          };
        };

        preset = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "silentSDDM theme preset name when theme.package is null.";
        };

        extraBackgrounds = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };

        themeOverrides = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };

        settings = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Extra values merged into services.displayManager.sddm.settings.";
        };
      };

      config = {
        assertions = [
          {
            assertion =
              (if config.my.login.sddm.enable or false then 1 else 0)
              + (if config.my.login.lemurs.enable or false then 1 else 0)
              + (if config.my.login.cosmic-greeter.enable or false then 1 else 0) <= 1;
            message = "Only one login manager may be enabled: my.login.sddm, my.login.lemurs, or my.login.cosmic-greeter.";
          }
        ];

        services.displayManager.sddm = lib.mkIf cfg.enable {
          inherit (cfg) package;
          enable = true;
          wayland.enable = cfg.wayland;
          theme = if cfg.theme.name != null then cfg.theme.name else activeTheme.pname;
          extraPackages =
            (if hasTheme then [ ] else activeTheme.propagatedBuildInputs) ++ cfg.theme.extraPackages;
          settings =
            lib.optionalAttrs (!hasTheme) {
              General = {
                GreeterEnvironment = "QML2_IMPORT_PATH=${activeTheme}/share/sddm/themes/${activeTheme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
                InputMethod = "qtvirtualkeyboard";
              };
            }
            // cfg.settings;
        };

        environment.systemPackages = lib.mkIf cfg.enable (
          lib.optionals cfg.includeThemePackage [ activeTheme ]
          ++ lib.optionals (cfg.theme.includeTestPackage && builtins.hasAttr "test" activeTheme) [
            activeTheme.test
          ]
        );
      };
    };
}
