# /nixos/modules/env.nix

#{ pkgs, ... }:

{
  #xdg = {
  #autostart.enable = true;
  #portal = {
  #enable = true;
  #extraPortals = [
  #pkgs.xdg-desktop-portal
  #pkgs.xdg-desktop-portal-gtk
  #];
  #};
  #};

  environment.sessionVariables = rec {
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];

    #XDG_SESSION_TYPE = "wayland";
    #GTK_USE_PORTAL = "1";
    #NIXOS_XDG_USE_PORTAL = "1";
  };
}
