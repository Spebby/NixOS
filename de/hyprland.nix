# /etc/nixos/de/hyprland.nix

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    meson
    waybar
    dunst
    libnotify
    #(waybar.overrideAtrrs (oldAttrs: {
    #    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #  })
    #)
    swaybg
    wofi
    stow
    swayidle
    hyprshot
  ];

  programs.hyprland.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
