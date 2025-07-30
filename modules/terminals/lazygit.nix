# /home-manager/modules/lazygit.nix

{ config, lib }:

let
  cfg = config.lazygit;
in
{
  options.lazygit = {
    enable = lib.mkEnableOption "Enable LazyGit terminal utility";
    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.any;
      default = {
        gui.showIcons = true;
        gui.theme = {
          lightTheme = false;
          activeBorderColor = [
            "green"
            "bold"
          ];
          inactiveBorderColor = [ "grey" ];
          selectedLineBgColor = [ "blue" ];
        };
      };
      description = "Lazygit GUI settings with theme and icons.";
    };
  };

  programs.lazygit = { inherit (cfg) enable settings; };
}
