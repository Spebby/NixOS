# /users/home-manager/max.nix

{
  inputs,
  pkgs,
  pkgs-stable,
  lib,
  ...
}:

{
  # Import all the home-manager modules
  imports = [ ../../modules/home-manager ];

  # And then selectively enable them as needed
  firefox.enable = true;
  discord = {
    enable = true;
    useCustomClient = false;
  };

  terminals = {
    kitty.enable = true;
    zsh.enable = true;
    starship.enable = true;
    bat.enable = true;
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      colors = "always";
      icons = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };

  lazygit.enable = true;
  yazi.enable = true;
  zathura.enable = true;

  # Games!
  protonUp.enable = true;

  hyprland.enable = false;
  gnome.enable = true;

  blender.enable = true;
  rider.enable = true;
  godot.enable = true;
  unity = {
    enable = true;
    useVerco = false;
  };

  # For
  home.packages = with pkgs; [
    google-chrome

    lutris # wine wrapper
    gh # github cli tool

    # Games
    prismlauncher # 3rd Party Minecraft Launcher

    # Desktop Apps
    pkgs-stable.audacity
    #gimp-with-plugins

    libreoffice-qt6
    mpv
    vlc
    obs-studio
    pinta

    geogebra6

    spotify # you know what this is
    #cider-2 # 3rd party apple music client

    # Steam Helpers
    steam-tui
    steamcmd

    # CLI Utilities
    acpid
    alsa-utils
    bc
    bottom
    brightnessctl
    btop
    fastfetch
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    netcat-gnu
    ntfs3g
    mediainfo
    microfetch
    playerctl # media player formatter
    ripgrep
    showmethekey # debugging keycodes for exotic keys
    silicon
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard # clipboard for wayland
    wtype
    yt-dlp # i forgor what this is
    zip
    inputs.nixvim.packages.${pkgs.system}.default # this is my neovim config im so cooool

    # CXX
    meson
    cpio
    doxygen_gui

    # ECMA
    nodejs
    #npm

    # WM
    libnotify
    xdg-desktop-portal-gtk
    gtt
  ];

  # Stylix Overrides
  stylix = lib.mkForce {
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml";

    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-light-rainbow.png";
      sha256 = "0mq378fqqafgzjl4l8lz1v0zv0d14v0b0abgqff7i4s0dcp8kbyg";
    };
    imageScalingMode = "fill";
  };

  programs.git = {
    enable = true;
    userName = "Max Brockmann";
    userEmail = "max.marika.brock@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}
