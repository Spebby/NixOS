{ _findFile, ... }:
{
  den.aspects.test = {
    includes = [
      <my/boot/secure>
      <my/desktops/cosmic>
      <my/login/cosmic-greeter>
    ];

    nixos = {
      imports = [
        ./_hardware-configuration.nix
        ../_common
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      networking.networkmanager.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;
    };
  };
}
