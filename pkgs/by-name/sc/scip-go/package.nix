{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scip-go";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "scip-go";
    tag = "v${version}";
    hash = "sha256-/3+vTz/W1mmI2zlVQLW4wPd66zK7HpFb8VaLFuUPRhk=";
  };

  vendorHash = "sha256-E/1ubWGIx+sGC+owqw4nOkrwUFJfgTeqDNpH8HCwNhA=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = false;

  meta = with lib; {
    description = "SCIP (SCIP Code Intelligence Protocol) indexer for Golang";
    homepage = "https://github.com/sourcegraph/scip-go/tree/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ arikgrahl ];
    mainProgram = "scip-go";
  };
}
