{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-modules";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "regexident";
    repo = "cargo-modules";

    rev = "58da6a3483a07b472a5faeeb574a8c7e72e15991";
    sha256 = "sha256-V274sWgWNxkmzP3rcsNm5LA/6XOBKCagE7SgrCx6yng=";
  };

  cargoSha256 = "sha256-faIHQsddLN4DGtRhsCTXSAyv0NAiPDie4JvwU64ZuVQ=";

  meta = with lib; {
    description = "A cargo subcommand for creating GraphViz DOT files and dependency graphs";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ ];
  };
}
