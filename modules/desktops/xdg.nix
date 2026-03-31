{
  my.xdg = {
    nixos.xdg.portal.enable = true;
    homeManager = {
      xdg = {
        enable = true;
        mimeApps.enable = true;
      };
    };
  };
}
