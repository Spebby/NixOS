# /users/home-manager/thom.nix

{
  lib,
  pkgs,
  pkgs-stable,
  ...
}:

let
  allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
in
{
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

  home = {
    # local packages
    packages = with pkgs; [
      #hytale-launcher
      reaper
      lutris
      gh
      melonds

      via

      # Desktop Apps
      pkgs-stable.audacity
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
      geogebra6

      cider-2

      # Test
      figma-linux
      davinci-resolve

      # CLI Utils
      alsa-utils
      bc
      bottom
      brightnessctl
      btop
      fastfetch
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
      losslesscut-bin

      # CXX - Adj
      meson
      cpio
      doxygen_gui

      # ECMA
      nodejs
      #npm

      # WM
      libnotify
      gtt
      distroshelf

      # EVIL
      opencode
    ];

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
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Thom Mott";
            email = "thommott@proton.me";
          };
          gpg.ssh.allowedSignersFile = allowedSigners;
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };

        lfs.enable = true;

        signing = {
          key = "~/.ssh/NixOS.pub";
          signByDefault = true;
        };
      };

      difftastic.enable = true;
      gpg.enable = true;
    };

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
  };
}
