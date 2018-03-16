{ stdenv
, fetchFromGitHub
, boost
, cmake
, itk
, withNipypeInterface ? true, python, nipype, bootstrapped-pip, wheel
}:

let
  inherit (stdenv) lib;
in stdenv.mkDerivation rec {
  name = "mirorr";

  src = if withNipypeInterface
    then fetchFromGitHub {
      owner = "ashgillman";
      repo = name;
      rev = "db9c9d3";
      sha256 = "0paby0m5hkrfj8wjz3a6rq9df8kk6nkw2n34lzyj4qfcl27gq81c";
    }
    else fetchFromGitHub {
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
    homepage = https://www.nitrc.org/projects/dcm2nii;
    license = licenses.mit; # CSIRO license, based on MIT/BSD
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
