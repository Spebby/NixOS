#usbutils /hosts/rosso/local-packages.nix

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
    mangohud
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports for Steam Remote Play
      dedicatedServer.openFirewall = true; # open ports for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports for Steam Local Network
      gamescopeSession.enable = true;
      extraPackages = with pkgs; [
        gamescope
        gamemode
        mangohud
      ];
    };

    gamemode = {
      enable = true;
    };
  };
}
