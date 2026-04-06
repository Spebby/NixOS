{
  den = {
    hosts.x86_64-linux = {
      rosso.users.max = {
        classes = [ "homeManager" ];
      };
      rosso.users.thom = {
        classes = [ "homeManager" ];
      };
      tink.users.max = {
        classes = [ "homeManager" ];
      };

      test.users.dummy = {
        classes = [ "homeManager" ];
      };
    };

    homes.x86_64-linux = {
      max = { };
      "max@rosso" = { };
      "max@tink" = { };

      thom = { };
      "thom@rosso" = { };

      dummy = { };
      "dummy@test" = { };
    };
  };
}
