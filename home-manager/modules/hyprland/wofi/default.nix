{ config, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
      width = 450;
      height = 500;
    };
  };

  home.file = {
    ".config/wofi/style.css".source = ./style.css;
    ".config/wofi/colours.css".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/stylix/colours.css";
  };
}
