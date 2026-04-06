{
  den = {
    hosts.x86_64-linux = {
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
      "max@tink" = {
        userName = "max";
        aspect = "max";
      };

      thom = { };
      "thom@rosso" = {
        userName = "thom";
        aspect = "thom";
      };

      dummy = { };
      "dummy@test" = {
        userName = "dummy";
        aspect = "dummy";
      };
    };
  };
}
