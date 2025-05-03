let
  pkgs = import <nixpkgs> { };
in
pkgs.buildFHSUserEnv {
  name = "plastic-env";
  targetPkgs =
    pkgs: with pkgs; [
      glibc
      zlib
      libuuid
      openssl
      curl
      libX11
      gtk3
      libxkbcommon
      xdg-utils
    ];
  runScript = "bash";
}
