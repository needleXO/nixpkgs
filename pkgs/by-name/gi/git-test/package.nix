{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  git,
}:

stdenv.mkDerivation rec {
  pname = "git-test";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "git-test";
    tag = "v${version}";
    sha256 = "01h3f0andv1p7pwir3k6n01v92hgr5zbjadfwl144yjw9x37fm2f";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -m755 -Dt $out/bin git-test
    install -m444 -Dt $out/share/man/man1 git-test.1

    wrapProgram $out/bin/git-test \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "Test your commits";
    homepage = "https://github.com/spotify/git-test";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "git-test";
  };
}
