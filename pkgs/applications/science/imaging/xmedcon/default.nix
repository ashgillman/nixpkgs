{ stdenv, fetchurl,
  glib,
  gdk_pixbuf,
  zlib,
  libpng,
  pkgconfig,
  gtk2
}:

stdenv.mkDerivation rec {
  name = "xmedcon-${version}";
  version = "0.14.1";

  src = fetchurl {
    url = "mirror://sourceforge/xmedcon/xmedcon-${version}.tar.bz2";
    sha256 = "0jb9mva5z7kgqx8vpnq93kg20pjxddcavqfnv1nckmnk8jzr9ld6";
  };

  enableParallelBuilding = true;
  patches = [ ./incr_path_len.patch ];
  buildInputs = [
    glib
    gdk_pixbuf
    zlib
    libpng
    pkgconfig
    gtk2
  ];

  meta = with stdenv.lib; {
    description = "An open-source medical image conversion toolkit";
    homepage = https://xmedcon.sourceforge.net;
    license = licenses.lgpl;
    maintainers = [ maintainers.ashgillman ];
    platforms = platforms.all;
  };
}
