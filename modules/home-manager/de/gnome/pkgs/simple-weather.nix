{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  gettext,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "simple-weather";
  version = "48.1.0";

  src = fetchFromGitHub {
    owner = "romanlefler";
    repo = "SimpleWeather";
    rev = "v${version}";
    hash = "sha256-pJglc2WWcNrDYnvcZu2xOxbbdRnDguRfAuBXbe4boHc=";
  };

  nativeBuildInputs = [
    nodejs
    gettext
  ];

  buildInputs = [
    glib
    gettext
  ];

  makeFlags = [ "INSTALLBASE=${placeholder "out"}/share/gnome-shell/extensions" ];

  passthru = {
    extensionUuid = "simple-weather@romanlefler.com";
    extensionPortalSlug = pname;
  };

  meta = with lib; {
    description = "A highly configurable GNOME shell extension for viewing the weather";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dkabot ];
    homepage = "https://github.com/romanlefler/SimpleWeather";
  };
}
