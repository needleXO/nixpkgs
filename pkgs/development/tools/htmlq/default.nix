{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "htmlq";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mgdm";
    repo = "htmlq";
    tag = "v${version}";
    sha256 = "sha256-kZtK2QuefzfxxuE1NjXphR7otr+RYfMif/RSpR6TxY0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QUlR6PuOLbeAHzARtTo7Zn7fmjs2ET6TdXT4VgCYEVg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "Like jq, but for HTML";
    homepage = "https://github.com/mgdm/htmlq";
    license = licenses.mit;
    maintainers = with maintainers; [
      siraben
      nerdypepper
    ];
    mainProgram = "htmlq";
  };
}
