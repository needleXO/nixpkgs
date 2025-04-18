{
  lib,
  fetchFromGitHub,
  buildGoModule,
  sqlite,
  callPackage,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gotify-server";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    tag = "v${version}";
    hash = "sha256-6PmJnRBovyufrSB+uMbU+bqhZb1bEs39MxBVMnnE6f8=";
  };

  # With `allowGoReference = true;`, `buildGoModule` adds the `-trimpath`
  # argument for Go builds which apparently breaks the UI like this:
  #
  #   server[780]: stat /var/lib/private/ui/build/index.html: no such file or directory
  allowGoReference = true;

  vendorHash = "sha256-aru1Q3esLtyxV6CVup4qjsuaJlM5DuLuP8El4RYoVVE=";

  doCheck = false;

  buildInputs = [
    sqlite
  ];

  ui = callPackage ./ui.nix { };

  preBuild = ''
    if [ -n "$ui" ] # to make the preBuild a no-op inside the goModules fixed-output derivation, where it would fail
    then
      cp -r $ui ui/build
    fi
  '';

  passthru = {
    # For nix-update to detect the location of this attribute from this
    # derivation.
    inherit (ui) offlineCache;
    updateScript = nix-update-script { };
    tests = {
      nixos = nixosTests.gotify-server;
    };
  };

  # Otherwise, all other subpackages are built as well and from some reason,
  # produce binaries which panic when executed and are not interesting at all
  subPackages = [ "." ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Mode=prod"
  ];

  meta = with lib; {
    description = "Simple server for sending and receiving messages in real-time per WebSocket";
    homepage = "https://gotify.net";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "server";
  };
}
