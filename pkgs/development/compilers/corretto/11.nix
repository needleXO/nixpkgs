{
  fetchFromGitHub,
  gradle_7,
  jdk11,
  lib,
  stdenv,
  rsync,
  runCommand,
  testers,
}:

let
  corretto = import ./mk-corretto.nix rec {
    inherit
      lib
      stdenv
      rsync
      runCommand
      testers
      ;
    jdk = jdk11;
    gradle = gradle_7;
    extraConfig = [
      # jdk11 is built with --disable-warnings-as-errors (see openjdk/11.nix)
      # because of several compile errors. We need to include this parameter for
      # Corretto, too.
      "--disable-warnings-as-errors"
    ];
    version = "11.0.25.9.1";
    src = fetchFromGitHub {
      owner = "corretto";
      repo = "corretto-11";
      tag = version;
      hash = "sha256-ewGGj4BHmwoPdULeT3PSI0Fo9T3cFbTO7cZXhzuKISY=";
    };
  };
in
corretto
