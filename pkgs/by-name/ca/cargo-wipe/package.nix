{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wipe";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "mihai-dinculescu";
    repo = "cargo-wipe";
    tag = "v${version}";
    sha256 = "sha256-xMYpZ6a8HdULblkfEqnqLjX8OVFJWx8MHDGNhuFzdTc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6Od0xP0Sp3839WbvN0VVAIsY8I1LAsR62yzXtcCSXQY=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = ''Cargo subcommand "wipe": recursively finds and optionally wipes all "target" or "node_modules" folders'';
    mainProgram = "cargo-wipe";
    homepage = "https://github.com/mihai-dinculescu/cargo-wipe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
