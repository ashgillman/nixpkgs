{ stdenv
, fetchFromGitHub
, boost
, cmake
, itk
, withNipypeInterface ? true, nipype ? null, bootstrapped-pip ? null
}:

let
  inherit (stdenv) lib;
in stdenv.mkDerivation rec {
  name = "mirorr";

  src = fetchFromGitHub {
    owner = "aehrc";
    repo = name;
    rev = "72994db";
    sha256 = "02a4jp7dg12zb15zy5d5ilhpw225xc8iqylmvx9nnxmwz7fg1698";
  };

  buildInputs = [
    boost
    cmake
    itk
  ];
  propagatedBuildInputs = lib.optional withNipypeInterface [ nipype ];

  cmakeFlags = [
    "-DUSE_NPW=OFF"
    "-DUSE_MIRORR_NON_SYSTEM_BOOST=ON"
    "-DCMAKE_CXX_STANDARD=11"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $prefix/bin
    cp -n bin/* $prefix/bin

    runHook postInstall
  '' + lib.optionalString withNipypeInterface ''
    pwd; ls
    pushd ../python
      ${bootstrapped-pip}/bin/pip install . --no-index --prefix=$out \
        --no-cache --build tmpbuild
    popd
  '';

  meta = with stdenv.lib; {
    description = "Multimodal Image Registration using blOck-matching and Robust Regression";
    homepage = http://aehrc.github.io/Mirorr/;
    license = licenses.mit; # CSIRO license, based on MIT/BSD
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
