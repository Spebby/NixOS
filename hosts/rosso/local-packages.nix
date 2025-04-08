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
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    nix-ld = {
      enable = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports for Steam Remote Play
      dedicatedServer.openFirewall = true; # open ports for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports for Steam Local Network
      protontricks.enable = true;

      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          "--hdr-itm-enable"
          "--rt"
          "--steam"
          "--nested-refresh"
          "165"
          "--output-width"
          "2560"
          "--output-height"
          "1600"
        ];
        env = {
          MANGOHUD = "1";
          MANGOHUD_CONFIG = "cpu_temp,gpu_temp,ram,vram";
        };
      };
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
