{
  lib,
  stdenv,
  fetchFromGitHub,
  gzip,
  popt,
  autoreconfHook,
  aclSupport ? stdenv.hostPlatform.isLinux,
  acl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "logrotate";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "logrotate";
    repo = "logrotate";
    tag = version;
    sha256 = "sha256-D7E2mpC7v2kbsb1EyhR6hLvGbnIvGB2MK1n1gptYyKI=";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  configureFlags = [
    "--with-compress-command=${gzip}/bin/gzip"
    "--with-uncompress-command=${gzip}/bin/gunzip"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ popt ] ++ lib.optionals aclSupport [ acl ];

  passthru.tests = {
    nixos-logrotate = nixosTests.logrotate;
  };

  meta = with lib; {
    homepage = "https://github.com/logrotate/logrotate";
    description = "Rotates and compresses system logs";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.tobim ];
    platforms = platforms.all;
    mainProgram = "logrotate";
  };
}
