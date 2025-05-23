{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  pkg-config,
  libgit2,
  zlib,
  buildPackages,
  withClipboard ? true,
  withTrash ? !stdenv.hostPlatform.isDarwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "1.45.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    tag = "v${version}";
    hash = "sha256-xLmVqYjQqjWMBm2A5OJl2wFIvxbWviX//J10BnKgWyk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8QRqRAXyqWS13TxUlSawjh/Qo4Qs5yQtNlqXj0hMW0c=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    pkg-config
  ];

  buildInputs =
    [
      libgit2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      zlib
    ];

  buildFeatures = lib.optionals withTrash [ "trash" ] ++ lib.optionals withClipboard [ "clipboard" ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  postPatch = ''
    # Fill the version stub in the man page. We can't fill the date
    # stub reproducibly.
    substitute man/page man/broot.1 \
      --replace "#version" "${version}"
  '';

  postInstall =
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      # Install shell function for bash.
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function bash > br.bash
      install -Dm0444 -t $out/etc/profile.d br.bash

      # Install shell function for zsh.
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function zsh > br.zsh
      install -Dm0444 br.zsh $out/share/zsh/site-functions/br

      # Install shell function for fish
      ${stdenv.hostPlatform.emulator buildPackages} $out/bin/broot --print-shell-function fish > br.fish
      install -Dm0444 -t $out/share/fish/vendor_functions.d br.fish

    ''
    + ''
      # install shell completion files
      OUT_DIR=$releaseDir/build/broot-*/out

      installShellCompletion --bash $OUT_DIR/{br,broot}.bash
      installShellCompletion --fish $OUT_DIR/{br,broot}.fish
      installShellCompletion --zsh $OUT_DIR/{_br,_broot}

      installManPage man/broot.1

      # Do not nag users about installing shell integration, since
      # it is impure.
      wrapProgram $out/bin/broot \
        --set BR_INSTALL no
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/broot --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    changelog = "https://github.com/Canop/broot/releases/tag/v${version}";
    maintainers = with maintainers; [ dywedir ];
    license = with licenses; [ mit ];
    mainProgram = "broot";
  };
}
