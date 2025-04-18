{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "liquidprompt";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "liquidprompt";
    repo = "liquidprompt";
    tag = "v${version}";
    hash = "sha256-ZVzFGe3ItWsN23iyGpxZEN2KtviYKI8x/sDa2MRio/Y=";
  };

  strictDeps = true;

  postPatch = ''
    patchShebangs tools/*.sh
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 0444 liquidprompt $out/bin/liquidprompt

    install -D -m 0444 liquidprompt.plugin.zsh \
      $out/share/zsh/plugins/liquidprompt/liquidprompt.plugin.zsh
    install -D -m 0444 liquidprompt \
      $out/share/zsh/plugins/liquidprompt/liquidprompt

    # generate default config file
    mkdir -p $out/share/doc/liquidprompt
    tools/config-from-doc.sh --verbose > $out/share/doc/liquidprompt/liquidpromptrc-dist

    mkdir -p $out/share/liquidprompt
    cp -a themes $out/share/liquidprompt/

    mkdir -p $out/share/liquidprompt/contrib
    cp -a contrib/presets $out/share/liquidprompt/contrib/

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Full-featured & carefully designed adaptive prompt for Bash & Zsh";
    homepage = "https://github.com/liquidprompt/liquidprompt";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ gerschtli ];
  };
}
