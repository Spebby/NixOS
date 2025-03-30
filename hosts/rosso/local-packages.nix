# /hosts/rosso/local-packages.nix

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # open ports for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports for Steam Local Network
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
}
