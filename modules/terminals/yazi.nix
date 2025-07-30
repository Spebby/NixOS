# /home-manager/modules/yazi.nix

{ pkgs, ... }:

# todo: https://github.com/yazi-rs/plugins/tree/main/git.yazi
{
  home.packages = with pkgs; [ yaziPlugins.git ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
}
