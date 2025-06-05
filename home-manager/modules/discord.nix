# /home-manager/modules/discord

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (discord-canary.override {
      withOpenASAR = true;
      withVencord = true;
    })

    vesktop
  ];
}
