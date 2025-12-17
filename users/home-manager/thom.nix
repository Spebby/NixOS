# /users/home-manager/thom.nix

{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-stable,
  ...
}:

let
  allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
in
{
  # Specific packages.
  imports = [ ../../modules/home-manager ];

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

  hyprland.enable = true;
  gnome.enable = true;

  blender.enable = true;
  rider.enable = true;
  godot.enable = true;
  unity = {
    enable = true;
    useVerco = true;
  };

  zed = {
    enable = true;
    settings = {
      ai = false;
      vim_mode = true;
    };
  };

  home = {
    # local packages
    packages = with pkgs; [
      aseprite
      reaper
      lutris
      gh

      # Games
      prismlauncher # Minecraft

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
      losslesscut-bin
      inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default

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
    ];

    file = {
      # GPG Signing for Git
      "${allowedSigners}".text =
        "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJHJvth1usDlafKm6M61C8nTy+YgVe7uizcFmqXqp3A thommott@proton.me";

      # Distrobox Config
      ".config/distrobox/distrobox.conf".text = ''
        # List of environment variables to pass from host to container
        container_envvars="DISPLAY WAYLAND_DISPLAY XAUTHORITY"

        # Optional: Also pass these common GUI variables
        container_envvars+=" QT_QPA_PLATFORM GDK_BACKEND CLUTTER_BACKEND"

        # If using Flatpak or other special cases
        container_envvars+=" DBUS_SESSION_BUS_ADDRESS"
        			'';
    };

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
}
