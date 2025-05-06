# /nixos/modules/env.nix

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
    ROFI_SCREENSHOT_DIR = "$HOME/Media/screenshots";
    PATH = [ "${XDG_BIN_HOME}" ];
    MOZ_USE_XINPUT2 = "1";

    #XDG_SESSION_TYPE = "wayland";
    #GTK_USE_PORTAL = "1";
    #NIXOS_XDG_USE_PORTAL = "1";
  };
}
