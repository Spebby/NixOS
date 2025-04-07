# /nixos/modules/audio.nix

{ pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true; # review if i actually need this one

    # This is not valid nix: Essentially, my PC always has the camera active,
    # even when it really should be disabled. With some TLP wizardry I could
    # probably figure it out... for now, don't worry about it.
    # This is apparently a pipewire/wireplumber specific bug. Need to research more.
    #    wireplumber.profiles = {
    #      main = {
    #        monitor.libcamera.enable = false;
    #      };
    #    };
  };

  environment.systemPackages = with pkgs; [ alsa-tools ];
}
