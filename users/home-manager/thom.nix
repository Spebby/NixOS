# /users/home-manager/thom.nix

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
in
{
  # Specific packages.
  imports = [ ../../modules ];

  terminals = {
    alacritty.enable = false;
    ghostty.enable = false;
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

  firefox.enable = true;
  discord = {
    enable = true;
    useCustomClient = true;
  };

  protonUp.enable = true;

  blender.enable = true;
  rider.enable = true;
  godot.enable = true;
  unity = {
    enable = true;
    useVerco = true;
  };

  home = {
    # local packages
    packages = with pkgs; [
      lutris
      gh

      inputs.yt-x.packages."${pkgs.system}".default

      # Games
      prismlauncher # Minecraft

      # Desktop Apps
      audacity
      #gimp-with-plugins
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

      # Test
      figma-linux
      davinci-resolve

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
      doxygen_gui

      # ECMA
      nodejs
      #npm

      # WM
      libsForQt5.xwaylandvideobridge
      libnotify
      xdg-desktop-portal-gtk
    ];

    # GPG Signing for Git
    file."${allowedSigners}".text =
      "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJHJvth1usDlafKm6M61C8nTy+YgVe7uizcFmqXqp3A thommott@proton.me";

    sessionVariables = rec {
      XDG_BOOKS_DIR = "$HOME/Media/Books";
      TERMINAL = lib.mkDefault (config.terminals.default or "kitty");
    };
  };

  # Stylix Overrides
  stylix = lib.mkForce {
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-rainbow.png";
      sha256 = "036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc";
    };
    imageScalingMode = "fill";
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Thom Mott";
    userEmail = "thommott@proton.me";
    extraConfig = {
      gpg.ssh.allowedSignersFile = allowedSigners;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    signing = {
      key = "~/.ssh/NixOS.pub";
      signByDefault = true;
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gtk2; # hyprland specific
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "dolphin.desktop" ];
    };
  };
}
