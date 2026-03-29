# /hosts/rosso/configuration.nix

{ pkgs, ... }:

{
  # TODO: move the theme specific stuff to machine specific configs.
  # I also like owl, Loader 2, Spinner Alt, Splash, Cuts Alt, DNA, Hexagon Dots Alt, Hexagons

  environment = {
    systemPackages = with pkgs; [
      home-manager
      bottles
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtgraphicaleffects

      dnsmasq
      phodav
    ];
  };

  cosmic = {
    enable = true;
    useCosmicGreeter = false;
  };
  gnome = {
    enable = false;
    usePowerProfile = false;
  };
  hyprland.enable = false;
  kde = {
    enable = false;
    useSDDM = true;
  };
}
