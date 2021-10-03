{ lib, rustPlatform, fetchFromGitHub, gst_all_1, glib, pkg-config }:
rustPlatform.buildRustPackage rec {
  pname = "termusic";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "tramhao";
    repo = "termusic";

    rev = "ec4435eb91985b33a98f7fe9742d9b76f04b87ad";
    sha256 = "sha256-+MRE1FnniWAG5INzoJNlxmXwtv2hl6qDF+hMW1p5m98=";
  };
  nativeBuildInputs = [
    glib
    pkg-config
  ];
  buildInputs = with gst_all_1; [ 
    gstreamer 
    gst-plugins-good 
    gst-plugins-bad 
    gst-plugins-base 
    gst-plugins-ugly
  ];
  cargoSha256 = "sha256-ZUlw2wzap3Cos8qrWxWP9wg+wxL0EfcRpHUQnUBuiMY=";

  meta = with lib; {
    description = "Music Player TUI written in Rust";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ ];
  };
}
