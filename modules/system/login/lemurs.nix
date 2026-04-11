_: {
  my.login.provides.lemurs.nixos =
    { lib, config, ... }:
    let
      cfg = config.my.login.lemurs;
    in
    {
      options.my.login.lemurs = {
        enable = lib.mkEnableOption "Enable lemurs login manager via greetd";

        autologin = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion =
              (if config.my.login.sddm.enable or false then 1 else 0)
              + (if config.my.login.lemurs.enable or false then 1 else 0)
              + (if config.my.login.cosmic-greeter.enable or false then 1 else 0) <= 1;
            message = "Only one login manager may be enabled: my.login.sddm, my.login.lemurs, or my.login.cosmic-greeter.";
          }
          {
            assertion = (!cfg.autologin.enable) || (cfg.autologin.user != null);
            message = "Set my.login.lemurs.autologin.user when autologin.enable = true.";
          }
        ];

        services.displayManager.sddm.enable = false;
        services.greetd = {
          enable = true;
          settings.default_session.command = "lemurs";
        };
      };
    };
}
