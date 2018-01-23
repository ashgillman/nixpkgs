{ stdenv
, fetchFromGitHub
, cmake
, boost
, itk
#, openmpi
, pythonPackages
, swig
}:

let
  nixpkgsVer = builtins.readFile <nixpkgs/.version>;
in stdenv.mkDerivation rec {
  name = "stir-3.0";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "STIR";
    rev = "9ef3b73";
    sha256 = "1l6dn0hxq4jp1niyrklclvlc7hddgn7jkyc60b50k06n6zf2sbb8";
  };

  buildInputs = [ boost cmake itk /*openmpi*/ ];
  propagatedBuildInputs = [ swig ] ++ ( with pythonPackages; [ python numpy ] );

  cmakeFlags = [
    "-DGRAPHICS=PGM"
    "-DSTIR_MPI=OFF" #"-DSTIR_MPI=ON"
    "-DSTIR_OPENMP=${if stdenv.isDarwin then "OFF" else "ON"}"
    "-DBUILD_SWIG_PYTHON=ON"
  ];
  preConfigure = ''
    rm -rf build
    cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"
  '';
  postInstall = ''
    # add scripts to bin
    find $src/scripts -type f ! -path "*maintenance*" -name "*.sh"  -exec cp -fn {} $out/bin \;
    find $src/scripts -type f ! -path "*maintenance*" ! -name "*.*" -exec cp -fn {} $out/bin \;
  '';

  pythonPath = ""; # Makes python.buildEnv include libraries
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Software for Tomographic Image Reconstruction";
    homepage = http://stir.sourceforge.net;
    license = with licenses; [ lgpl21 gpl2 free ]; # free = custom PARAPET license
  };
}
