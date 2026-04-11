{
  my.apps._.fun.provides = {
    terminal.nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          cowsay
          cbonsai
          sl
          fortune
          asciiquarium-transparent
          cmatrix
          toilet
          oneko
          aalib
          rig
          microfetch
        ];
      };

    graphical.nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          mesa-demos
          silicon
        ];
      };
  };
}
