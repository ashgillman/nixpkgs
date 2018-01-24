{ stdenv
, fetchFromGitHub
, boost
, cmake
, itk
}:

stdenv.mkDerivation rec {
  name = "mirorr";

  src = fetchFromGitHub {
    owner = "aehrc";
    repo = name;
    rev = "1d4b1506613129a566fdb8532d3031c3c29cc626";
    sha256 = "1gv1akl1fqayz46w3cch00akk5gm532rajq05967qysr6wqxma4r";
  };

  buildInputs = [
    boost
    cmake
    itk
  ];

  cmakeFlags = [
    "-DUSE_NPW=OFF"
    "-DUSE_MIRORR_NON_SYSTEM_BOOST=ON"
    "-DCMAKE_CXX_STANDARD=11"
  ];

  installPhase = ''
    mkdir -p $prefix/bin
    cp -n bin/* $prefix/bin
  '';

  meta = with stdenv.lib; {
    description = "Multimodal Image Registration using blOck-matching and Robust Regression";
    homepage = https://www.nitrc.org/projects/dcm2nii;
    license = licenses.mit; # CSIRO license, based on MIT/BSD
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
