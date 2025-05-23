{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  zlib,
}:
stdenv.mkDerivation rec {
  version = "0.5.3";
  pname = "wiiload";

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ zlib ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo = "wiiload";
    tag = "v${version}";
    sha256 = "sha256-pZdZzCAPfAVucuiV/q/ROY3cz/wxQWep6dCTGNn2fSo=";
  };

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "Load homebrew apps over network/usbgecko to your Wii";
    mainProgram = "wiiload";
    homepage = "https://wiibrew.org/wiki/Wiiload";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
