{ callPackage, stdenv, overrideCC, gcc6, vtk, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.11.0";
  sha256 = "0axvyds0gads5914g0m70z5q16gzghr0rk0hy3qjpf1k9bkxvcq6";

  stdenv = overrideCC stdenv gcc6;
  vtk = vtk.override {
    stdenv = overrideCC stdenv gcc6;
  };

  extraPatches = [
    # Clang 4 dislikes signed comparisons of pointers against integers. Should
    # no longer be necessary after ITK 4.11.
    (fetchpatch {
      url = "https://github.com/InsightSoftwareConsortium/ITK/commit/d1407a55910ad9c232f3d241833cfd2e59024946.patch";
      sha256 = "0h851afkv23fwgkibjss30fkbz4nkfg6rmmm4pfvkwpml23gzz7s";
    })
  ];
})
