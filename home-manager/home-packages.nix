# /home-manager/home-packages.nix

{ inputs, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
    };

    #overlays = [ (import ./packages) ];
  };

  # Packages I don't have specific configs for
  home.packages = with pkgs; [
    # Desktop Apps
    audacity
    gimp-with-plugins
    libreoffice-qt6
    mission-center
    mpv
    obs-studio
    pinta
    slack
    thunderbird
    vlc
    zoom-us
    en-croissant
    geogebra6

    cider-2
    gitkraken

    # Test
    figma-linux
    davinci-resolve

    # Steam Helpers
    steam-tui
    steamcmd

    # Thunar File Manager
    xfce.thunar
    xfce.xfconf

    # CLI Utils
    acpid
    alsa-utils
    bat
    bc
    bottom
    brightnessctl
    btop
    fastfetch
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    htop
    netcat-gnu
    ntfs3g
    mediainfo
    microfetch
    playerctl
    ripgrep
    showmethekey
    silicon
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip
    inputs.nixvim.packages.${pkgs.system}.default

    # CXX - Adj
    meson
    cpio

    # ECMA
    nodejs
    #npm

    python311

    # WM
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
  ];
}
