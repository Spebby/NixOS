{
  my.apps._.terminal =
    let
      executableMap = {
        alacritty = "alacritty";
        ghostty = "ghostty";
        kitty = "kitty";
        wezterm = "wezterm";
      };
      xdgDesktopMap = {
        alacritty = "Alacritty.desktop";
        ghostty = "com.mitchellh.ghostty.desktop";
        kitty = "kitty.desktop";
        wezterm = "org.wezfurlong.wezterm.desktop";
      };
    in
    {
      nixos =
        { config, ... }:
        let
          cfg = config.my.apps._.terminal;
        in
        {
          xdg.terminal-exec.settings.default = [ xdgDesktopMap.${cfg.emulator} ];

          environment.sessionVariables = rec {
            TERMINAL = executableMap.${cfg.emulator};
          };
        };

      homeManager =
        { config, lib, ... }:
        let
          cfg = config.my.apps._.terminal;
        in
        {
          # FIXME: this is probably in wrong spot
          options.my.apps._.terminal = {
            emulator = lib.mkOption {
              type = lib.types.enum [
                "alacritty"
                "ghostty"
                "kitty"
                "wezterm"
              ];
              default = "kitty";
              description = "Which terminal emulator to enable and treat as the system default.";
            };
            executableOverride = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                Override the terminal executable used by other modules.
                If null, derived automatically from the emulator option.
              '';
            };
            kitty.extraConfig = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Extra lines appended to the Kitty config.";
            };
            wezterm.configFile = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = ''
                Path to a Lua file used as the WezTerm config.
                Required when emulator = "wezterm".
              '';
            };
          };

          config = {
            assertions = [
              {
                assertion = cfg.emulator != "wezterm" || cfg.wezterm.configFile != null;
                message = "my.apps._.terminal: wezterm.configFile must be set when emulator is \"wezterm\".";
              }
            ];
            home.sessionVariables.TERMINAL = lib.mkDefault (
              if cfg.executableOverride != null then cfg.executableOverride else executableMap.${cfg.emulator}
            );
            programs = {
              alacritty = lib.mkIf (cfg.emulator == "alacritty") {
                enable = true;
                settings.font = {
                  builtin_box_drawing = true;
                  normal.style = lib.mkForce "Bold";
                };
              };
              ghostty = lib.mkIf (cfg.emulator == "ghostty") { enable = true; };
              kitty = lib.mkIf (cfg.emulator == "kitty") {
                enable = true;
                extraConfig = ''
                  confirm_os_window_close 0
                ''
                + cfg.kitty.extraConfig;
              };
              wezterm = lib.mkIf (cfg.emulator == "wezterm") {
                enable = true;
                extraConfig = lib.mkIf (cfg.wezterm.configFile != null) (builtins.readFile cfg.wezterm.configFile);
              };
            };
          };
        };
    };
}
