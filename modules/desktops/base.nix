{ my, ... }:
{
  my.desktops._.base = {
    includes = [ my.xdg ];

    nixos = {
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      programs.xwayland.enable = true;
    };

    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };

    homeManager.home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
