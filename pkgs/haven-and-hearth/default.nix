{ lib, stdenv, fetchurl, makeWrapper, jdk8, javaPackages, libXxf86vm }:
stdenv.mkDerivation rec {
  pname = "haven-and-heart";
  version = "0.0.0";

  src = fetchurl {
    url = "http://www.havenandhearth.com/java/hafen-launcher.jar";
    sha256 = "sha256-a26k0NckzFVf1pIw3gmKDFxJ44vBFcGxoGyMSKT0QtU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ jdk8 javaPackages.jogl_2_3_2 makeWrapper  libXxf86vm ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/hafen-launcher.jar

    echo ${libXxf86vm}

    cat 1>$out/bin/hafen <<EOF
    #!/usr/bin/env bash

    ${jdk8}/bin/java \
      -Djava.library.path=${libXxf86vm}/lib \
      -jar $out/hafen-launcher.jar
    EOF

    chmod +x $out/bin/hafen
  '';

  meta = with lib; {
    description = "Haven & Hearth is a MMORPG set in a fictional world loosely inspired by Slavic and Germanic myth and legend.";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ ];
  };
}
