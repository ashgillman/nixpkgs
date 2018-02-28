{ stdenv, fetchurl, fetchpatch, cmake, libX11, libuuid, xz, vtk
, withReview ? true
, withVtk ? true
, version, sha256, extraBuildInputs ? [], extraCMakeFlags ? [], ...
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

  # Clang 4 dislikes signed comparisons of pointers against integers. Should no longer be
  # necessary after ITK 4.11.
  patches = optional (compareVersions version "4.11.0" == 0) [
    (fetchpatch {
      url    = "https://github.com/InsightSoftwareConsortium/ITK/commit/d1407a55910ad9c232f3d241833cfd2e59024946.patch";
      sha256 = "0h851afkv23fwgkibjss30fkbz4nkfg6rmmm4pfvkwpml23gzz7s";
    }) ];

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
