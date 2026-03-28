{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      ntfs3g
      git
      home-manager
      openssl
      wget
      keychain
      alsa-tools
      pavucontrol
      ffmpeg-full
      clang
      gcc
      meson
      cmake
      gnumake
      cpio
      binutils
      gdb
      python311
      live-server
      zig
      odin
      vim
      nano
      acpid
      cowsay
      door-knocker
      gparted
      ncdu
      lsof
      pciutils
      udisks
      mesa-demos
      lshw-gui
      usbutils
      cbonsai
      nix-prefetch-git
      wayland-utils
      edid-decode
      sddm-astronaut
      sddm-chili-theme
      nurl
      nix-your-shell
    ];

    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    sessionVariables = rec {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      XDG_BIN_HOME = "$HOME/.local/bin";
      ROFI_SCREENSHOT_DIR = "$HOME/Media/screenshots/";
      PATH = [ "${XDG_BIN_HOME}" ];
      MOZ_USE_XINPUT2 = "1";
    };

    variables = {
      CC = "clang";
      CXX = "clang++";
    };
  };
}
