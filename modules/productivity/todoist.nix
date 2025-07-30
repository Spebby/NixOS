# /modules/productivity/todoist.nix

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.todoist;
in
{
  options.todoist.enable = lib.mkEnableOption "Enable Todoist";

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [ todoist-electron ];

      file = {
        ".local/share/applications/todoist.desktop" = {
          text = ''
            [Desktop Entry]
            Name=Todoist
            Exec=${pkgs.todoist-electron}/bin/todoist-electron --ozone-platform-hint=auto -- --no-sandbox %U
            Terminal=false
            Type=Application
            Icon=todoist
            StartupWMClass=Todoist
            X-AppImage-Version=9.8.0
            MimeType=x-scheme-handler/todoist;x-scheme-handler/com.todoist;
            Comment=The Best To-Do List App & Task Manager
            Categories=Office;
            				'';
        };
      };
    };
  };
}
