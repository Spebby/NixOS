{ inputs, ... }:
{
  my.apps._.editors._.vim.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.vim
        inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
