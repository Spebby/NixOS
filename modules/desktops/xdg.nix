{
  my.xdg = {
    nixos =
      { pkgs, ... }:
      {
        xdg.portal.enable = true;
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
