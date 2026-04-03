{
  my.apps._.stylix.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.stylix;
    in
    {
      options.my.apps._.stylix = {
        polarity = lib.mkOption {
          type = lib.types.enum [
            "dark"
            "light"
          ];
          default = "dark";
          description = "Theme polarity.";
        };
        base16Scheme = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
          description = "Base16 scheme file used by Stylix.";
        };
        image = lib.mkOption {
          type = lib.types.path;
          default = pkgs.fetchurl {
            url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-rainbow.png";
            sha256 = "036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
          };
          description = "Wallpaper/image used by Stylix.";
        };

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Additional packages to install alongside the default Stylix font packages.";
        };

        # --- opacity ---
        opacity = {
          applications = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Opacity for applications.";
          };
          desktop = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Opacity for the desktop.";
          };
          popups = lib.mkOption {
            type = lib.types.float;
            default = 0.9;
            description = "Opacity for popups.";
          };
          terminal = lib.mkOption {
            type = lib.types.float;
            default = 0.95;
            description = "Opacity for terminals.";
          };
        };

        # --- fonts ---
        fonts = {
          emoji = {
            name = lib.mkOption {
              type = lib.types.str;
              default = "Noto Color Emoji";
              description = "Emoji font name.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.noto-fonts-color-emoji;
              description = "Emoji font package.";
            };
          };
          monospace = {
            name = lib.mkOption {
              type = lib.types.str;
              default = "JetBrains Mono";
              description = "Monospace font name.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.jetbrains-mono;
              description = "Monospace font package.";
            };
          };
          sansSerif = {
            name = lib.mkOption {
              type = lib.types.str;
              default = "Noto Sans";
              description = "Sans-serif font name.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.noto-fonts;
              description = "Sans-serif font package.";
            };
          };
          serif = {
            name = lib.mkOption {
              type = lib.types.str;
              default = "Noto Serif";
              description = "Serif font name.";
            };
            package = lib.mkOption {
              type = lib.types.package;
              default = pkgs.noto-fonts;
              description = "Serif font package.";
            };
          };
          sizes = {
            applications = lib.mkOption {
              type = lib.types.int;
              default = 11;
              description = "Font size for applications.";
            };
            desktop = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Font size for the desktop.";
            };
            popups = lib.mkOption {
              type = lib.types.int;
              default = 10;
              description = "Font size for popups.";
            };
            terminal = lib.mkOption {
              type = lib.types.int;
              default = 13;
              description = "Font size for terminals.";
            };
          };
        };

        # --- icons ---
        icons = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable Stylix icon theming.";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.papirus-icon-theme;
            description = "Icon theme package.";
          };
          dark = lib.mkOption {
            type = lib.types.str;
            default = "Papirus-Dark";
            description = "Dark icon theme name.";
          };
          light = lib.mkOption {
            type = lib.types.str;
            default = "Papirus-Light";
            description = "Light icon theme name.";
          };
        };

        # --- targets ---
        targets = {
          neovim.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix neovim target.";
          };
          waybar.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix waybar target.";
          };
          wofi.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix wofi target.";
          };
          hyprland.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix hyprland target.";
          };
          hyprlock.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix hyprlock target.";
          };
          swaync.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Stylix swaync target.";
          };
          gtk.extraCss = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Extra CSS for the GTK target.";
          };
        };
      };

      config = {
        home.packages =
          with pkgs;
          [
            dejavu_fonts
            jetbrains-mono
            noto-fonts
            texlivePackages.hebrew-fonts
            noto-fonts-color-emoji
            nerd-fonts.symbols-only
            font-awesome
            powerline-fonts
            powerline-symbols
          ]
          ++ cfg.extraPackages;

        stylix = {
          enable = true;
          autoEnable = true;
          inherit (cfg) polarity base16Scheme image;
          imageScalingMode = "fill";

          opacity = {
            inherit (cfg.opacity)
              applications
              desktop
              popups
              terminal
              ;
          };

          fonts = {
            emoji = { inherit (cfg.fonts.emoji) name package; };
            monospace = { inherit (cfg.fonts.monospace) name package; };
            sansSerif = { inherit (cfg.fonts.sansSerif) name package; };
            serif = { inherit (cfg.fonts.serif) name package; };
            sizes = {
              inherit (cfg.fonts.sizes)
                applications
                desktop
                popups
                terminal
                ;
            };
          };

          icons = {
            inherit (cfg.icons)
              enable
              package
              dark
              light
              ;
          };

          targets = {
            bat.enable = true;
            ghostty.enable = true;
            firefox.enable = false;
            neovim.enable = cfg.targets.neovim.enable;
            waybar.enable = cfg.targets.waybar.enable;
            wofi.enable = cfg.targets.wofi.enable;
            hyprland.enable = cfg.targets.hyprland.enable;
            hyprlock.enable = cfg.targets.hyprlock.enable;
            swaync.enable = cfg.targets.swaync.enable;
            gtk = {
              enable = true;
              flatpakSupport.enable = true;
              inherit (cfg.targets.gtk) extraCss;
            };
          };

          cursor = {
            name = "DMZ-Black";
            size = 24;
            package = pkgs.vanilla-dmz;
          };
        };

        home.file.".config/stylix/colours.css".text = ''
          @define-color base00 ${config.lib.stylix.colors.withHashtag.base00}; /* bg0 */
          @define-color base01 ${config.lib.stylix.colors.withHashtag.base01}; /* bg1 */
          @define-color base02 ${config.lib.stylix.colors.withHashtag.base02}; /* b2 */
          @define-color base03 ${config.lib.stylix.colors.withHashtag.base03}; /* b3 */
          @define-color base04 ${config.lib.stylix.colors.withHashtag.base04}; /* fg3 */
          @define-color base05 ${config.lib.stylix.colors.withHashtag.base05}; /* fg2 */
          @define-color base06 ${config.lib.stylix.colors.withHashtag.base06}; /* fg1 */
          @define-color base07 ${config.lib.stylix.colors.withHashtag.base07}; /* fg0 */
          @define-color base08 ${config.lib.stylix.colors.withHashtag.base08}; /* red */
          @define-color base09 ${config.lib.stylix.colors.withHashtag.base09}; /* orange */
          @define-color base0A ${config.lib.stylix.colors.withHashtag.base0A}; /* yellow */
          @define-color base0B ${config.lib.stylix.colors.withHashtag.base0B}; /* green */
          @define-color base0C ${config.lib.stylix.colors.withHashtag.base0C}; /* aqua */
          @define-color base0D ${config.lib.stylix.colors.withHashtag.base0D}; /* blue */
          @define-color base0E ${config.lib.stylix.colors.withHashtag.base0E}; /* purple */
          @define-color base0F ${config.lib.stylix.colors.withHashtag.base0F}; /* orange */
        '';
      };
    };
}
