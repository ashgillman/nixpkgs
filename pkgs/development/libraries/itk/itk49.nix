{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.9.1";
  sha256 = "1sghdw4m8y2lzn330l6ybc69fal8h5fmif937i6g4d9bl2qd9mip";
})
