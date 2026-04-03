{
  my.apps._.fun.provides =
    { pkgs, ... }:
    {
      terminal.nixos = {
        environment.systemPackages = with pkgs; [
          cowsay
          cbonsai
          sl
          fortune
          asciiquarium-transparent
          cmatrix
          xcowsay
          yes
          toilet
          oneko
          aalib
          rig
        ];
      };

      graphical.nixos = {
        environment.systemPackages = with pkgs; [ mesa-demos ];
      };
    };
}
