{ inputs, __findFile, ... }:
{
  den.hosts.x86_64-linux.test.instantiate =
    args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);

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

      networking.networkmanager.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;
    };
  };
}
