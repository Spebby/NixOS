{
  # Highly recommend installing direnv everywhere plugin to get around
  # Rider's weirdness with the toolchain
  my.apps._.editors._.rider.homeManager = { pkgs, ... }: {
    options.my.apps._.rider = { };

    config = {
      home.packages = [ pkgs.jetbrains.rider ];
    };
  };
}
