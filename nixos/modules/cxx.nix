# /nixos/modules/cxx.nix

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clang
    gcc
    meson
    cmake
    gnumake
    cpio
    git
    binutils

    nano
    vim
  ];

  environment.variables = {
    CC = "clang";
    CXX = "clang++";
  };
}
