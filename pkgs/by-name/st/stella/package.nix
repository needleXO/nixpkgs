{
  lib,
  SDL2,
  fetchFromGitHub,
  sqlite,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stella";
  version = "7.0c";

  src = fetchFromGitHub {
    owner = "stella-emu";
    repo = "stella";
    tag = finalAttrs.version;
    hash = "sha256-AbZBBg4P0qnB+mZpiG8/kHixBfkKQptyLrF4lwgRr/Y=";
  };

  nativeBuildInputs = [
    SDL2
    pkg-config
  ];

  buildInputs = [
    SDL2
    sqlite
  ];

  strictDeps = true;

  meta = {
    homepage = "https://stella-emu.github.io/";
    description = "Open-source Atari 2600 VCS emulator";
    longDescription = ''
      Stella is a multi-platform Atari 2600 VCS emulator released under the GNU
      General Public License (GPL). Stella was originally developed for Linux by
      Bradford W. Mott, and is currently maintained by Stephen Anthony. Since
      its original release several people have joined the development team to
      port Stella to other operating systems such as AcornOS, AmigaOS, DOS,
      FreeBSD, IRIX, Linux, OS/2, MacOS, Unix, and Windows. The development team
      is working hard to perfect the emulator and we hope you enjoy our effort.

      As of its 3.5 release, Stella is officially donationware.
    '';
    changelog = "https://github.com/stella-emu/stella/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "stella";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
