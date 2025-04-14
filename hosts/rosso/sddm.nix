# /hosts/rosso/ssdm/

{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "rosso-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Spebby";
    repo = "sddm-rosso";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
}
