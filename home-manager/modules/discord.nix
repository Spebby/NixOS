# /home-manager/modules/discord

{ pkgs, lib, ... }:

{
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
