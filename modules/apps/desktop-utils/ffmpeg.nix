{
  my.apps._.ffmpeg.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ ffmpeg-full ];
    };
}
