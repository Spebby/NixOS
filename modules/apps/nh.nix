{
  my.apps._.nh = {
    homeManager =
      { config, ... }:
      {
        programs.ng = {
          enable = true;
          osFlake = "${config.home.homeDirectory}/.flake";
        };
      };
  };
}
