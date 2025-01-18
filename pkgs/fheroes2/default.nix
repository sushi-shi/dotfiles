{ stdenv, fetchFromGitHub, fetchurl
, SDL2_mixer, SDL2_ttf, SDL2_image, SDL2
, zlib, gettext
, unzip
}:


stdenv.mkDerivation rec {
  pname = "fheroes2";
  version = "0.9.0";

  buildInputs = [ SDL2_mixer SDL2_ttf SDL2_image SDL2 ];
  nativeBuildInputs = [ zlib unzip gettext ];
  makeFlags = [
    "WITH_SDL2=1"
  ];

  src = fetchFromGitHub {
    owner = "ihhub";
    repo = pname;
    rev = "b720838ba654f1131f0c5777d2d140f979a76322";
    sha256 = "sha256-msFuBKG/uuXxOcPf0KT3TWOiQrQ4rYHFxOcJ56QBkEU=";
  };

  demo = fetchurl {
    url = "https://archive.org/download/HeroesofMightandMagicIITheSuccessionWars_1020/h2demo.zip";
    sha256 = "sha256-EgSMiwOHXIHmlTSjgTqvY0CXXne3YtwbeaT/VRQkDjw=";
  };

  installPhase = ''
    mkdir -p $out/bin
    unzip ${demo} -d $out
    ls -lAh
    mv ./fheroes2 $out

    cat 1>$out/bin/fheroes2 <<EOF
    #!/usr/bin/env bash
    $out/fheroes2
    EOF

    chmod +x $out/bin/fheroes2

  '';
}
