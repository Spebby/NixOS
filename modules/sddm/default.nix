{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.silentSDDM;

  sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    inherit (cfg)
      theme
      extraBackgrounds
      ;
    theme-overrides = cfg.themeOverrides;
  };
in
{
  options.silentSDDM = {
    enable = lib.mkEnableOption "SilentSDDM theme module";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "default";
    };

    extraBackgrounds = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };

    themeOverrides = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    addTestPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ sddm-theme ] ++ lib.optional cfg.addTestPackage sddm-theme.test;

    services.displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      enable = true;
      wayland.enable = true;
      theme = sddm-theme.pname;
      extraPackages = sddm-theme.propagatedBuildInputs;
      settings.General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };
}
