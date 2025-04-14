# /home-manager/home-packages.nix

{ inputs, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
    };

    overlays = [ (import ./packages) ];
  };

  # Packages I don't have specific configs for
  home.packages = with pkgs; [
    # Desktop Apps
    blender
    cider-2
    discord
    gimp-with-plugins
    libreoffice-qt6
    mission-center
    mpv
    obs-studio
    obsidian
    pinta
    slack
    thunderbird
    vlc
    xfce.thunar
    xfce.xfconf
    zoom-us
    en-croissant

    # Steam Helpers
    steam-tui
    steamcmd

    # CLI Utils
    acpid
    alsa-utils
    bat
    bc
    bottom
    brightnessctl
    btop
    cliphist
    fastfetch
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    grimblast
    htop
    hyprpicker
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
    xdg-desktop-portal-hyprland

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}
