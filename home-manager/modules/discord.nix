# /home-manager/modules/discord

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
