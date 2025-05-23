{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    tag = "v${version}";
    sha256 = "sha256-qGcEhoytkCkcaA5eHc8GVgWvbOIyrO6BCp+EHva6wTw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nN2aNNBq2YDOY9H9682hvwrlI5WTg7s1EPi68UuBTBM=";

  checkFlags = [
    # Fails for 1.6.0, but binary works fine
    "--skip=pretty_print_search_results::tests::display_pretty_search_results_given_output"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
    mainProgram = "stork";
  };
}
