{ lib, config, ... }:
let
  cfg = lib.attrByPath [ "den" "default" "security" ] { } config;
  sudoRsExecWheelOnly = lib.attrByPath [ "sudo-rs" "execWheelOnly" ] true cfg;
  doasEnable = lib.attrByPath [ "doas" "enable" ] true cfg;
  pamLoginLimits = lib.attrByPath [ "pam" "loginLimits" ] [ ] cfg;

  myOptions = {
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
in
{
  options.den.default.security = myOptions;

  config.den.default.nixos = {
    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        execWheelOnly = sudoRsExecWheelOnly;
      };
      doas = {
        enable = doasEnable;
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
        loginLimits = pamLoginLimits;
      };
    };
  };
}
