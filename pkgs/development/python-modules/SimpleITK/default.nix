{ buildPythonPackage
, fetchFromGitHub
, lib
, python
, numpy
#, virtualenv
, cmake
, git
, gtest
, itk
, lua5_1
, swig
, tcl
, tk
}:

buildPythonPackage rec {
  pname = "simpleitk";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    rev = "v${version}";
    sha256 = "1pk7wmrbxi92ws3f8dkm9zdyq8vfag1v6pymb079qpnbsakgynkj";
  };

  #format = "wheel";
  preConfigure = ''
    # virtualenv is a wrapper, not Python file.
    substituteInPlace CMake/FindPythonVirtualEnv.cmake \
      --replace ' ''${PYTHON_EXECUTABLE} ''${PYTHON_VIRTUALENV_SCRIPT}' \
                ' ''${PYTHON_VIRTUALENV_SCRIPT}'
  '';
  configurePhase = "cmakeConfigurePhase";
  buildPhase = "buildPhase";  # Use the standard make buildPhase
  postBuild = ''
    cd Wrapping/Python
    SOURCE_DATE_EPOCH=$(date +%s) ${python.interpreter} Packaging/setup.py bdist_wheel
  '';
  cmakeFlags = [
    # "-DGTEST_ROOT=${pkgs.gtest}"
    # Some error finding GTest
    "-DBUILD_TESTING=OFF"
    "-DSimpleITK_FORBID_DOWNLOADS=ON"
    "-DSimpleITK_PYTHON_USE_VIRTUALENV=OFF"
  ];
  doCheck = false;

  buildInputs = [ cmake git gtest itk lua5_1 swig tcl tk ];
  propagatedBuildInputs = [ numpy ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.simpleitk.org;
    license = licenses.apache2;
    description = "Multiple language wrapper for ITK";
    maintainers = with maintainers; [ ashgillman ];
  };
}
