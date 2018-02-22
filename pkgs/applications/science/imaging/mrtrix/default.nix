{ stdenv
, fetchFromGitHub
, python, numpy
, eigen , mesa , qmake , qtscript , qtsvg , x11 , zlib
, justMrview ? false
}:

stdenv.mkDerivation rec {
  name = "MRtrix3-${version}";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "MRtrix3";
    repo = "mrtrix3";
    rev = "${version}";
    sha256 = "1h2r1i6qs09cpb476cqwk5fcq7q2g4cqrzadavvf3bz66dr81ir8";
  };

  nativeBuildInputs = [
    qmake
  ];
  buildInputs = [
    python
    numpy
    eigen
    mesa
    qtscript
    qtsvg
    x11
    zlib
  ];

  EIGEN_CFLAGS = "-isystem ${eigen}/include/eigen3";
  dontAddPrefix = true;
  enableParallelBuilding = true;

  # NB: MRtrix doesn't use standard configure and make, but custom Python scripts

  # We need qmake, but don't actually use qmakeConfigurePhase
  configurePhase = ''
    runHook preConfigure

    patchShebangs .
    LD=$CXX ./configure

    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild

    if [ -z "$enableParallelBuilding" ]; then
      export NUMBER_OF_PROCESSORS="1"
    else
      export NUMBER_OF_PROCESSORS="$NIX_BUILD_CORES"
    fi
    ./build ${if justMrview then "release/bin/mrview" else ""}

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv release/{bin,lib} $out

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Advanced tools for the analysis of diffusion MRI data";
    longDescription = ''
      MRtrix3 provides a set of tools to perform various types of diffusion
      MRI analyses, from various forms of tractography through to
      next-generation group-level analyses.
    '';
    homepage = http://www.mrtrix.org/;
    license = licenses.mpl20;
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
