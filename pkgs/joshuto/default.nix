{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = "7c6bb9ca1b3d7fb61a4cfc5c997ae0e247bd5acc";
    sha256 = "sha256-m/T4owqeYY8kOmeScON9SBRzLMv6pBpdmEhYHD8jB74=";
  };

  cargoSha256 = "sha256-/qRynazRfazfx4sfAnQR2fSUFas/YVqzsO0GGrgXYY4=";

}
