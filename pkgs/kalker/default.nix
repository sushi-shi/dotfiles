{ lib, rustPlatform, fetchFromGitHub, m4 }:
rustPlatform.buildRustPackage rec {
  pname = "kalker";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "PaddiM8";
    repo = "kalker";

    rev = "240e706dba9875223c606640d5bb31d2f45f94b3";
    sha256 = "sha256-1iZvp30/V0bw9NBxiKNiDgOMYJkDsGhTGdBsAPggdEg=";
  };
  nativeBuildInputs = [ m4 ];
  cargoSha256 = "sha256-fBWnMlOLgwrOBPS2GIfOUDHQHcMMaU5r9JZVMbA+W58=";

  meta = with lib; {
    description = "Kalker/kalk is a calculator with math syntax that supports user-defined variables and functions, complex numbers, and estimation of derivatives and integrals";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
