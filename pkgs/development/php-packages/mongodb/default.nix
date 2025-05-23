{
  stdenv,
  buildPecl,
  fetchFromGitHub,
  lib,
  libiconv,
  pcre2,
  pkg-config,
  cyrus_sasl,
  icu64,
  openssl,
  snappy,
  zlib,
  darwin,
}:

buildPecl rec {
  pname = "mongodb";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    tag = version;
    hash = "sha256-BMa0JOhk3jMiuhKX9AcGC2cpL1K0mocOs5wH8F43F0U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      cyrus_sasl
      icu64
      openssl
      snappy
      zlib
      pcre2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.Libsystem
      libiconv
    ];

  meta = {
    description = "Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    maintainers = lib.teams.php.members;
  };
}
