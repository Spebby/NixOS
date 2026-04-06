_: {
  my.login.provides.cosmic-greeter.nixos =
    { lib, config, ... }:
    let
      cfg = config.my.login.cosmic-greeter;
    in
    {
      options.my.login.cosmic-greeter = {
        enable = lib.mkEnableOption "Enable COSMIC greeter login manager";

        extraConfig = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Extra options merged into services.displayManager.cosmic-greeter.";
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
        ];

        services = {
          displayManager = {
            cosmic-greeter = {
              enable = true;
            }
            // cfg.extraConfig;
            sddm.enable = false;
          };
          greetd.enable = false;
        };
      };
    };
}
