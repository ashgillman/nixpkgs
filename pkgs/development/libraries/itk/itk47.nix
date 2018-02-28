{ stdenv, callPackage, overrideCC, gcc49, libminc, vtk, ... } @ args:

callPackage ./generic.nix (args // {
  # Required old gcc, for both itk and vtk
  stdenv = overrideCC stdenv gcc49;
  vtk = vtk.override {
    stdenv = overrideCC stdenv gcc49;
  };

  version = "4.7.2";
  sha256 = "1rda671a0qyari3rm14m76a3bmp7sh403vhzc22833ja1dihhjrq";
  extraBuildInputs = [ libminc ] ++ libminc.buildInputs;
  extraCMakeFlags = [
    "-DITK_USE_SYSTEM_MINC=ON"
    "-DLIBMINC_DIR=${libminc}/lib"
  ];
})
