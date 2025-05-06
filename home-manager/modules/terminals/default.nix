# /home-manager/modules/terminals/default.nix

{ lib, ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          builtin_box_drawing = true;
          normal = {
            style = lib.mkForce "Bold";
          };
        };
      };
    };

    kitty = {
      enable = true;
      extraConfig = ''
        confirm_os_window_close 0
      '';
    };

    ghostty = {
      enable = true;
    };
  };
}
