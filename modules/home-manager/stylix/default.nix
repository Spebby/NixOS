# /home-manager/modules/stylix.nix

{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  imports = [ inputs.stylix.homeModules.stylix ];

  home.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-lgc-plus
    texlivePackages.hebrew-fonts
    noto-fonts-color-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];

  stylix = lib.mkDefault {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    targets = {
      bat.enable = true;
      ghostty.enable = true;

      firefox.enable = false;
      neovim.enable = false;
      waybar.enable = false;
      wofi.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      swaync.enable = false;

      gtk = {
        enable = true;
        extraCss = "";
        flatpakSupport.enable = true;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 1.0;
      popups = 0.9;
      terminal = 0.95;
    };

    cursor = {
      name = "DMZ-Black";
      size = 24;
      package = pkgs.vanilla-dmz;
    };

    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      monospace = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };

      sizes = {
        applications = 11;
        desktop = 10;
        popups = 10;
        terminal = 13;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-rainbow.png";
      sha256 = "036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
    };
    imageScalingMode = "fill";
  };

  home.file.".config/stylix/colours.css".text = ''
    @define-color base00 ${config.lib.stylix.colors.withHashtag.base00}; /* bg0 */
    @define-color base01 ${config.lib.stylix.colors.withHashtag.base01}; /* bg1 */
    @define-color base02 ${config.lib.stylix.colors.withHashtag.base02}; /* b2 */
    @define-color base03 ${config.lib.stylix.colors.withHashtag.base03}; /* b3 */
    @define-color base04 ${config.lib.stylix.colors.withHashtag.base04}; /* fg3 */
    @define-color base05 ${config.lib.stylix.colors.withHashtag.base05}; /* fg2 */
    @define-color base06 ${config.lib.stylix.colors.withHashtag.base06}; /* fg1 */
    @define-color base07 ${config.lib.stylix.colors.withHashtag.base07}; /* fg0 */
    @define-color base08 ${config.lib.stylix.colors.withHashtag.base08}; /* red */
    @define-color base09 ${config.lib.stylix.colors.withHashtag.base09}; /* orange */
    @define-color base0A ${config.lib.stylix.colors.withHashtag.base0A}; /* yellow */
    @define-color base0B ${config.lib.stylix.colors.withHashtag.base0B}; /* green */
    @define-color base0C ${config.lib.stylix.colors.withHashtag.base0C}; /* aqua */
    @define-color base0D ${config.lib.stylix.colors.withHashtag.base0D}; /* blue */
    @define-color base0E ${config.lib.stylix.colors.withHashtag.base0E}; /* purple */
    @define-color base0F ${config.lib.stylix.colors.withHashtag.base0F}; /* orange */
  '';
}
