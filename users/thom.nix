# /users/thom.nix

{
  users = {
    users.thom = {
      isNormalUser = true;
      home = "/home/thom";
      icon = ./icons/thom.png;
      extraGroups = [
        "wheel"
        "networkmanager"
        "home-manager"
        "gamemode"
      ];
    };
  };
}
