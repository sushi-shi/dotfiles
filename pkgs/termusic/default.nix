{ lib, rustPlatform, fetchFromGitHub, gst_all_1, glib, pkg-config, wrapGAppsHook }:
rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";

    rev = "c1bdddfcea11d581c8fdf0a3798dd64af9d031a3";
    sha256 = "sha256-5xE4xdSPDf2WhXIfFKLTHlvzJYIf+qkf9tdzJMnEwZQ=";
  };
  nativeBuildInputs = [
    glib
    pkg-config
    wrapGAppsHook
  ];
  buildInputs = with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-ugly
  ];
  cargoSha256 = "sha256-HFzt/7MqIRy/tKMW6+D1PYc8r8HBEwc6NREvwOUpnl0=";

  meta = with lib; {
    description = "Music Player TUI written in Rust";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ ];
  };
}
