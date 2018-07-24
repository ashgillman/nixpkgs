{ stdenv, fetchurl, fetchpatch, cmake, libX11, libuuid, xz, vtk
, withReview ? true
, withVtk ? true
, version, sha256
, extraBuildInputs ? [], extraCMakeFlags ? [], extraPatches ? [], ...
}:

assert withVtk -> vtk != null;

with stdenv.lib;
with builtins;

stdenv.mkDerivation {
  name = "itk${if withVtk then "-vtk" else ""}${if withReview then "-rev" else ""}-${version}";

  src = fetchurl {
    inherit sha256;
    url = "mirror://sourceforge/itk/InsightToolkit-${version}.tar.xz";
  };

  patches = extraPatches;

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DModule_ITKMINC=ON"
    "-DModule_ITKIOMINC=ON"
    "-DModule_ITKIOTransformMINC=ON"
    "-DModule_ITKVtkGlue=${if withVtk then "ON" else "OFF"}"
    "-DModule_ITKReview=${if withReview then "ON" else "OFF"}"
  ] ++ extraCMakeFlags;

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake xz ];
  buildInputs = [ libX11 libuuid ]
    ++ extraBuildInputs
    ++ optional withVtk [ vtk ];

  meta = {
    description = "Insight Segmentation and Registration Toolkit";
    homepage = http://www.itk.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
