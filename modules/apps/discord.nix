{
  my.apps._.discord.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.discord;
    in
    {
      options.my.apps._.discord = {
        useCustomClient = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Install Vesktop alongside Discord.";
        };
        withOpenASAR = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Build Discord with OpenASAR enabled.";
        };
        withVencord = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Build Discord with Vencord enabled.";
        };
      };

      config = {
        home.packages = [
          (pkgs.discord.override { inherit (cfg) withOpenASAR withVencord; })
        ]
        ++ lib.optionals cfg.useCustomClient [ pkgs.vesktop ];
      };
    };
}
