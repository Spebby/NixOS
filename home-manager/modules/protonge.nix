{ pkgs, ... }:

{
  home.packages = with pkgs; [ protonup ];

  # Make sure to run "protonup" every now and then.
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
