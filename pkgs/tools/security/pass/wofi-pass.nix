{
  lib,
  stdenv,
  fetchFromGitHub,
  pass-wayland,
  coreutils,
  gnugrep,
  libnotify,
  pwgen,
  findutils,
  makeWrapper,
  wl-clipboard,
  wtype,
  wofi,
  extensions ? exts: [ ],
}:

let
  wrapperPath = lib.makeBinPath [
    coreutils
    findutils
    gnugrep
    libnotify
    pwgen
    wofi
    wl-clipboard
    wtype
    (pass-wayland.withExtensions extensions)
  ];
in
stdenv.mkDerivation rec {
  pname = "wofi-pass";
  version = "24.1.0";

  src = fetchFromGitHub {
    owner = "schmidtandreas";
    repo = "wofi-pass";
    tag = "v${version}";
    sha256 = "sha256-oRGDhr28UQjr+g//fWcLKWXqKSsRUWtdh39UMFSaPfw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 wofi-pass -t $out/bin
    install -Dm755 wofi-pass.conf -t $out/share/doc/wofi-pass/wofi-pass.conf
  '';

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/wofi-pass \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Script to make wofi work with password-store";
    homepage = "https://github.com/schmidtandreas/wofi-pass";
    maintainers = with lib.maintainers; [ akechishiro ];
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    mainProgram = "wofi-pass";
  };
}
