# /users/home-manager/thom.nix

{ pkgs, ... }:

{
  home.packages = with pkgs; [ lutris ];

  programs.git = {
    enable = true;
    userName = "Thom Mott";
    userEmail = "thommott@proton.me";
    extraConfig.init.defaultBranch = "main";
  };
}
