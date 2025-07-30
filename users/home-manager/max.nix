# /users/home-manager/max.nix

{ pkgs, lib, ... }:

{
  # Import all the home-manager modules
  imports = [ ../../modules/home-manager ];

  # And then selectively enable them as needed
  firefox.enable = true;
  discord = {
    enable = true;
    customClient.enable = false;
  };

  # For
  home.packages = with pkgs; [ neofetch ];

  # Stylix Overrides
  stylix = lib.mkForce {
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-medium.yaml";

    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-light-rainbow.png";
      sha256 = "0mq378fqqafgzjl4l8lz1v0zv0d14v0b0abgqff7i4s0dcp8kbyg";
    };
    imageScalingMode = "fill";
  };

  programs.git = {
    enable = true;
    userName = "Max Brockmann";
    userEmail = "max.marika.brock@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}
