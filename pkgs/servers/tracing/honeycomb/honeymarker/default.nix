{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
import ./versions.nix (
  { version, sha256 }:
  buildGoModule {
    pname = "honeymarker";
    inherit version;
    vendorHash = "sha256-ZuDobjC/nizZ7G0o/zVTQmDfDjcdBhfPcmkhgwFc7VU=";

    src = fetchFromGitHub {
      owner = "honeycombio";
      repo = "honeymarker";
      tag = "v${version}";
      hash = sha256;
    };

    meta = with lib; {
      description = "provides a simple CRUD interface for dealing with per-dataset markers on honeycomb.io";
      homepage = "https://honeycomb.io/";
      license = licenses.asl20;
      maintainers = [ maintainers.iand675 ];
    };
  }
)
