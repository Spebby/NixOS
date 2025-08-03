{
  mkDerivation,
  base,
  containers,
  emojis,
  fetchgit,
  hedgehog,
  lib,
  optparse-applicative,
  parsec,
  template-haskell,
  text,
  utf8-string,
}:
mkDerivation {
  pname = "dconf2nix";
  version = "nixos";
  src = fetchgit {
    url = "https://github.com/nix-community/dconf2nix.git";
    sha256 = "1qvyhhf6kvbs1kvv9xmcg3wb62w9syba9zx47m218hd20aqs4h3l";
    rev = "153a3e9ea154a733e38a9f61e358f2aa01194155";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    containers
    emojis
    optparse-applicative
    parsec
    text
    utf8-string
  ];

  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base
    containers
    hedgehog
    parsec
    template-haskell
    text
  ];
  description = "Convert dconf files to Nix, as expected by Home Manager";
  license = lib.licenses.asl20;
  mainProgram = "dconf2nix";
}
