# /users/max.nix

{
  users = {
    users.max = {
      isNormalUser = true;
      home = "/home/max";
      icon = ./icons/max.png;
      extraGroups = [
        "wheel"
        "networkmanager"
        "home-manager"
        "gamemode"
      ];
    };
  };
}
