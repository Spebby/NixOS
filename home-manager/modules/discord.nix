# /home-manager/modules/discord

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (discord-canary.override {
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
