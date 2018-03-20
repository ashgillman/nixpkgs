{ stdenv
, buildPythonPackage
, fetchPypi
# python dependencies
, cython
, h5py
, nibabel
, numpy
, scipy
# , pytest
}:

buildPythonPackage rec {
  pname = "dipy";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "063xiwyrgqaz7i0l64pbs78nmzajbn64wjmv3x8fhzv2h9a9xwzi";
  };

  # doCheck = false;  # fails with TypeError: None is not callable
  # buildInputs = [ pytest mock ];  # required in installPhase
  checkInputs = [ cython ];
  propagatedBuildInputs = [
    h5py
    nibabel
    numpy
    scipy
  ];

  meta = with stdenv.lib; {
    # homepage = http://nipy.org/nipype/;
    # description = "Neuroimaging in Python: Pipelines and Interfaces";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
