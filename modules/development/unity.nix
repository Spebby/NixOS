# /home-manager/modules/unity.nix

{ pkgs, ... }:

# Unity is superrrr cool and uses an old version of openssl for no good reason
{
  home.packages = with pkgs; [
    openssl_1_1
    (pkgs.unityhub.override {
      extraLibs =
        pkgs: with pkgs; [
          openssl_1_1
          harfbuzz
          libogg
        ];
    })
    verco # Plastic SCM client
  ];

  xdg.desktopEntries.unityhub = {
    name = "Unity Hub";
    # Note: env GDK_SCALE=2 GDK_DPI_SCALE=0.5 works well for higher res displays. Does not work great for my laptop!
    exec = "${pkgs.unityhub}/bin/unityhub --ozone-platform-hint=auto --  %U";
    icon = "unityhub";
    comment = "The Official Unity Hub";
    type = "Application";
    categories = [ "Development" ];
    settings = {
      StartupWMClass = "UnityHub";
      Terminal = "false";
      TryExec = "unityhub";
      MimeType = "x-scheme-handler/unityhub";
    };
  };
}
