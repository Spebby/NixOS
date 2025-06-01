# /users/home-manager/thom.nix

{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
in
{
  home = {
    packages = with pkgs; [
      lutris
      gh

      inputs.yt-x.packages."${pkgs.system}".default

      # Games
      prismlauncher # Minecraft
    ];

    # GPG Signing for Git
    file."${allowedSigners}".text =
      "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJHJvth1usDlafKm6M61C8nTy+YgVe7uizcFmqXqp3A thommott@proton.me";

    sessionVariables = rec {
      XDG_BOOKS_DIR = "$HOME/Media/Books";
      TERMINAL = "kitty";
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
