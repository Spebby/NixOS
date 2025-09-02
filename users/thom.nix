# /users/thom.nix

{
  users = {
    users.thom = {
      isNormalUser = true;
      home = "/home/thom";
      extraGroups = [
        "wheel"
        "networkmanager"
        "home-manager"
        "gamemode"
      ];
    };
  };
}
