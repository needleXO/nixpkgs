{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  future,
  numpy,
  pillow,
  scipy,
  scikit-learn,
  scikit-image,
  threadpoolctl,
}:

buildPythonPackage rec {
  pname = "batchgenerators";
  version = "0.25";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "batchgenerators";
    tag = "v${version}";
    hash = "sha256-L2mWH2t8PN9o1M67KDdl1Tj2ZZ02MY4icsJY2VNrj3A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    future
    numpy
    pillow
    scipy
    scikit-learn
    scikit-image
    threadpoolctl
  ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78
  pythonRemoveDeps = [ "unittest2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # see https://github.com/MIC-DKFZ/batchgenerators/pull/78
  disabledTestPaths = [ "tests/test_axis_mirroring.py" ];

  pythonImportsCheck = [
    "batchgenerators"
    "batchgenerators.augmentations"
    "batchgenerators.dataloading"
    "batchgenerators.datasets"
    "batchgenerators.transforms"
    "batchgenerators.utilities"
  ];

  meta = with lib; {
    description = "2D and 3D image data augmentation for deep learning";
    homepage = "https://github.com/MIC-DKFZ/batchgenerators";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
