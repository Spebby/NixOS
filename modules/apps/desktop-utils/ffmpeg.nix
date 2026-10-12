{
  my.apps._.ffmpeg.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.my.apps._.ffmpeg = {
        useFull = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      config = {
        environment.systemPackages = [
          (if config.my.apps._.ffmpeg.useFull then pkgs.ffmpeg-full else pkgs.ffmpeg)
        ];
      };
    };
}
