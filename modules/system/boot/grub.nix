{ lib, ... }:
{
  my.boot.provides = {
    grub.nixos =
      { config, ... }:
      {
        options.my.boot.grub = {
          enable = lib.mkEnableOption "GRUB bootloader profile";

          efiSupport = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable GRUB EFI support.";
          };

          devices = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "nodev" ];
            description = "GRUB install targets (nodev for EFI-only).";
          };

          useOSProber = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable os-prober integration for GRUB.";
          };

          configurationLimit = lib.mkOption {
            type = lib.types.int;
            default = 10;
            description = "How many boot generations GRUB keeps in menu.";
          };

          timeout = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Optional GRUB timeout (null leaves default behavior).";
          };

          theme = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Optional GRUB theme directory path.";
          };

          memtest86 = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable GRUB memtest86 entries.";
            };

            params = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "onepass" ];
              description = "Kernel-style params passed to memtest86.";
            };
          };
        };

        config =
          let
            grubCfg = config.my.boot.grub;
          in
          lib.mkIf grubCfg.enable {
            boot.loader = {
              grub = {
                inherit (grubCfg)
                  efiSupport
                  devices
                  useOSProber
                  configurationLimit
                  ;
                enable = true;
                memtest86 = { inherit (grubCfg.memtest86) enable params; };
              }
              // lib.optionalAttrs (grubCfg.theme != null) (
                let
                  inherit (grubCfg) theme;
                in
                {
                  inherit theme;
                }
              );

              timeout = lib.mkIf (grubCfg.timeout != null) (lib.mkDefault grubCfg.timeout);
            };
          };
      };
  };
}
