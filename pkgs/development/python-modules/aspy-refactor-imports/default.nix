{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  stdenv,
}:

buildPythonPackage rec {
  pname = "aspy-refactor-imports";
  version = "3.0.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "aspy.refactor_imports";
    tag = "v${version}";
    sha256 = "MlCM3zNTQZJ1RWrTQG0AN28RUepWINKCeLENykbu2nw=";
  };

  pythonImportsCheck = [ "aspy.refactor_imports" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # fails on darwin due to case-insensitive file system
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_application_directory_case" ];

  meta = with lib; {
    description = "Utilities for refactoring imports in python-like syntax";
    homepage = "https://github.com/asottile/aspy.refactor_imports";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
