{
  my.apps._.audio-tools.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        alsa-tools
        alsa-utils
        pavucontrol
      ];
    };
}
