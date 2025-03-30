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
