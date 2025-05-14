# /home-manager/modules/discord

{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  # "lucky day" fix
  home.file = {
    ".config/discord/settings.json" = {
      text = ''
        {
        	"SKIP_HOST_UPDATE": true
        }
      '';
    };
  };
}
