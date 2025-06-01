# /home-manager/modules/discord

{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
    })

    vesktop
  ];
}
