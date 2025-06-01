# /home-manager/modules/yazi.nix

{ pkgs-unstable, ... }:

# todo: https://github.com/yazi-rs/plugins/tree/main/git.yazi
{
  home.packages = with pkgs-unstable; [ yaziPlugins.git ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}
