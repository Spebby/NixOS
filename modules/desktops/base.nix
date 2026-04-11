{ my, ... }:
{
  my.desktops._.base = {
    includes = [ my.xdg ];

    nixos =
      { pkgs, ... }:
      {
        environment = {
          sessionVariables.NIXOS_OZONE_WL = "1";
          systemPackages = with pkgs; [
            wlr-randr
            wayland-utils
            showmethekey
            wl-clipboard
            wtype
          ];
        };
        programs.xwayland.enable = true;
      };

    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };

    homeManager.home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
