{
  stdenv,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calamares-nixos-extensions";
  version = "0.3.22";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "calamares-nixos-extensions";
    tag = finalAttrs.version;
    hash = "sha256-Tmp/sWQmhiZe2dmA+msCMPwPlBd1Oa3q5X+QP+CoAWI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,share}/calamares
    cp -r modules $out/lib/calamares/
    cp -r config/* $out/share/calamares/
    cp -r branding $out/share/calamares/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Calamares modules for NixOS";
    homepage = "https://github.com/NixOS/calamares-nixos-extensions";
    license = with licenses; [
      gpl3Plus
      bsd2
      cc-by-40
      cc-by-sa-40
      cc0
    ];
    maintainers = with maintainers; [ vlinkz ];
    platforms = platforms.linux;
  };
})
