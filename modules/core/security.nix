{
  den.default.nixos =
    { config, lib, ... }:
    let
      cfg = config.den.default.security;
    in
    {
      options.den.default.security = {
        sudo-rs.execWheelOnly = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Restrict sudo-rs to members of the wheel group only.";
        };
        doas.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable doas as an alternative to sudo.";
        };
        pam.loginLimits = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                domain = lib.mkOption { type = lib.types.str; };
                item = lib.mkOption { type = lib.types.str; };
                type = lib.mkOption {
                  type = lib.types.enum [
                    "hard"
                    "soft"
                    "-"
                  ];
                };
                value = lib.mkOption {
                  type = lib.types.oneOf [
                    lib.types.str
                    lib.types.int
                  ];
                };
              };
            }
          );
          default = [ ];
          description = "PAM login limits.";
        };
      };

      config.security = {
        sudo.enable = false;
        sudo-rs = {
          enable = true;
          execWheelOnly = cfg.sudo-rs.execWheelOnly;
        };
        doas = {
          enable = cfg.doas.enable;
          extraRules = [
            {
              keepEnv = true;
              groups = [ "wheel" ];
              noPass = true;
            }
          ];
        };
        polkit.enable = true;
        pam = {
          services.systemd-run0 = { };
          loginLimits = cfg.pam.loginLimits;
        };
      };
    };
}
