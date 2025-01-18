{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "joshuto";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "kamiyaa";
    repo = pname;
    rev = "75081aae369feb8e71977701ec9cb467e2b166ba";
    sha256 = "sha256-Z4xCT3AS2gjJdHPdnWppUnDVyrVSlw7nPD/T7PUOJJs=";
  };

  cargoSha256 = "sha256-7mx8q5VPsCK6T+BSnSYGh7v0jIVjpgKFOTO47waNyIU=";

}
