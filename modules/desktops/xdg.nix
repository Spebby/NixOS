{
  my.xdg = {
    nixos =
      { pkgs, ... }:
      {
        xdg.portal = {
          enable = true;
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        };

        environment = {
          systemPackages = with pkgs; [ door-knocker ];
          pathsToLink = [ "/share/xdg-desktop-portal" ];
        };
      };

    homeManager = {
      xdg = {
        enable = true;
        mimeApps.enable = true;
      };
    };
  };
}
