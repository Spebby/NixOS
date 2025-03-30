# /home-manager/modules/yazi.nix

{ lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    # Eventually, it may be worth putting the entire default
    # keymap here and modifying it as I wish. For the moment,
    # I like the default keymap well enough that I'll keep
    # using it.
  };
}
