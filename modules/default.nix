{ inputs, __findFile, ... }:
let
  stateVersion = "24.11";
in
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  den.default = {
    includes = [
      <den/home-manager>
      <den/define-user>
      <my/userIcons>
      (
        { host, ... }:
        {
          ${host.class}.networking.hostName = host.name;
        }
      )
    ];
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        cfg = config.den.default;
      in
      {
        imports = with inputs; [
          home-manager.nixosModules.home-manager
          nixos-facter-modules.nixosModules.facter
        ];

        options.den.default = {
          shell = {
            binSh = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = pkgs.bashInteractive;
              description = ''
                Package whose bin/sh is used as /bin/sh.
                Set to null to leave /bin/sh at its NixOS default (bash).
              '';
              example = lib.literalExpression "pkgs.busybox";
            };
            defaultPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = ''
                Contents of <option>environment.defaultPackages</option>.
                Defaults to empty (lean installs); add e.g. pkgs.nano if needed.
              '';
            };
          };

          locale = {
            defaultLocale = lib.mkOption {
              type = lib.types.str;
              default = "en_US.UTF-8";
              description = "System-wide default locale.";
            };
            supportedLocales = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "all" ];
              description = "Locales to generate. \"all\" is convenient but slow to build; narrow this on constrained hosts.";
              example = [
                "en_US.UTF-8/UTF-8"
                "ja_JP.UTF-8/UTF-8"
              ];
            };
            timeZone = lib.mkOption {
              type = lib.types.str;
              default = "America/Los_Angeles";
              description = "System time zone.";
              example = "Europe/London";
            };
          };

          network = {
            avahi = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable Avahi mDNS/DNS-SD for local network discovery.";
            };
          };

          dbus = {
            implementation = lib.mkOption {
              type = lib.types.enum [
                "broker"
                "dbus"
              ];
              default = "broker";
              description = ''
                D-Bus implementation to use.
                "broker" (dbus-broker) is lower overhead and the modern default.
              '';
            };
          };

          boot = {
            initrdSystemd = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Use systemd in initrd (enables TPM2, LUKS2 with systemd-cryptenroll, etc.).";
            };
          };

          memory = {
            zramSwap = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable zram-based compressed swap.";
            };
            zramPercent = lib.mkOption {
              type = lib.types.int;
              default = 50;
              description = "Percentage of RAM to allocate for zram swap (when zramSwap is enabled).";
            };
          };

          docs = {
            extraOutputsToInstall = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "man"
                "info"
              ];
              description = "Extra package outputs to install globally. Keep this lean to avoid pulling heavyweight doc outputs.";
            };
            doc = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Build and install HTML/PDF documentation.";
            };
            info = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Build and install GNU info pages.";
            };
            man = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Build and install man pages.";
            };
            nixosOptions = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Build the NixOS options doc (expensive; disable on constrained hosts).";
            };
          };

          homeManager = {
            useUserPackages = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Install home-manager packages into the user profile rather than home.packages.";
            };
            useGlobalPkgs = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Use the system nixpkgs in home-manager (avoids a second nixpkgs eval).";
            };
          };
        };

        config = {
          hardware.enableRedistributableFirmware = true;

          programs.zsh.enable = true;
          users.defaultUserShell = pkgs.zsh;

          environment = {
            binsh = lib.mkIf (cfg.shell.binSh != null) "${cfg.shell.binSh}/bin/sh";
            defaultPackages = lib.mkForce cfg.shell.defaultPackages;
            extraOutputsToInstall = lib.mkForce cfg.docs.extraOutputsToInstall;
            systemPackages = with pkgs; [
              git
              nix-your-shell
            ];

            # TODO: This is seemingly a 6 year old bug... but zsh, graphical shell, something or the other
            # prevents sessionVariables set in home-manager from overriding nixos set ones.
            # so, this is ugly af, but will have to go for now because AFAIK there isn't
            # a sane solution for this problem
            sessionVariables = {
              EDITOR = lib.mkDefault "nvim";
              MANPAGER = lib.mkDefault "nvim +Man!";
            };
          };

          services = {
            avahi.enable = cfg.network.avahi;
            dbus.implementation = cfg.dbus.implementation;
          };

          documentation = {
            doc.enable = cfg.docs.doc;
            info.enable = cfg.docs.info;
            man.enable = cfg.docs.man;
            nixos.enable = cfg.docs.nixosOptions;
          };

          i18n = { inherit (cfg.locale) defaultLocale supportedLocales; };

          time.timeZone = cfg.locale.timeZone;

          zramSwap = lib.mkIf cfg.memory.zramSwap {
            enable = true;
            memoryPercent = cfg.memory.zramPercent;
          };

          system.stateVersion = stateVersion;

          boot.initrd.systemd.enable = cfg.boot.initrdSystemd;

          home-manager = {
            inherit (cfg.homeManager) useUserPackages useGlobalPkgs;
            backupFileExtension = "hmBackup";
          };
        };
      };

    homeManager =
      { config, lib, ... }:
      let
        cfg = config.den.default.home;
      in
      {
        imports = [
          inputs.hyprland-unity-fix.nixosModules.hyprlandUnityFixModule
          inputs.stylix.homeModules.stylix
        ];

        options.den.default.home = {
          allowUnfree = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Set NIXPKGS_ALLOW_UNFREE=1 in the session environment.";
          };

          extraSessionPath = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "$HOME/.local/bin" ];
            description = "Entries prepended to the user PATH via sessionPath.";
            example = [
              "$HOME/.cargo/bin"
              "$HOME/go/bin"
            ];
          };

          extraSessionVariables = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Extra session variables merged alongside the defaults.";
            example = lib.literalExpression ''
              {
                EDITOR = "nvim";
                MANPAGER = "nvim +Man!";
              }
            '';
          };

          xdg = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Manage XDG base directories (config, cache, data, state).";
            };
            mimeApps = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable xdg.mimeApps management via home-manager.";
            };
          };

          fonts = {
            enableFontconfig = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable fontconfig management (allows home-manager to install and configure fonts).";
            };
          };

          programs = {
            manpager = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "nvim +Man!";
              description = "Override the MANPAGER variable. Null leaves it unset.";
              example = "nvim +Man!";
            };
            defaultEditor = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "nvim";
              description = "Set the EDITOR session variable. Null leaves it unset.";
              example = "nvim";
            };
          };
        };

        config = {
          gtk.gtk4.theme = null;
          nixpkgs.config.allowUnfree = true;
          programs.home-manager.enable = true;

          xdg = lib.mkIf cfg.xdg.enable {
            enable = true;
            mimeApps.enable = cfg.xdg.mimeApps;
          };

          fonts.fontconfig.enable = cfg.fonts.enableFontconfig;

          home = {
            sessionPath = cfg.extraSessionPath;
            inherit stateVersion;
            sessionVariables =
              lib.optionalAttrs cfg.allowUnfree { NIXPKGS_ALLOW_UNFREE = "1"; }
              // lib.optionalAttrs (cfg.programs.defaultEditor != null) {
                EDITOR = lib.mkDefault cfg.programs.defaultEditor;
              }
              // lib.optionalAttrs (cfg.programs.manpager != null) {
                MANPAGER = lib.mkDefault cfg.programs.manpager;
              }
              // cfg.extraSessionVariables;
          };
        };
      };
  };
}
