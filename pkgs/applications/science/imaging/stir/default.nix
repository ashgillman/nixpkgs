{ stdenv
, fetchFromGitHub
, cmake , boost , itk , swig
, buildPython ? true, python, numpy
}:

let
  nixpkgsVer = builtins.readFile <nixpkgs/.version>;
in stdenv.mkDerivation rec {
  name = "stir-3.1-pre";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "STIR";
    rev = "a470096"; # master: 18/01/23
    sha256 = "0g0aw4alj2ci4gj6g623zylw9hs1i9s52dvay3g76szfya4fw70x";
  };

  buildInputs = [ boost cmake itk /*openmpi*/ ];
  propagatedBuildInputs = [ swig ]
    ++ stdenv.lib.optional buildPython [ python numpy ];

  cmakeFlags = [
    "-DGRAPHICS=PGM"
    "-DSTIR_MPI=OFF" #"-DSTIR_MPI=ON"
    "-DSTIR_OPENMP=${if stdenv.isDarwin then "OFF" else "ON"}"
    "-DBUILD_SWIG_PYTHON=ON"
  ];
  preConfigure = stdenv.lib.optionalString buildPython ''
    cmakeFlags="-DPYTHON_DEST=$out/${python.sitePackages} $cmakeFlags"
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
