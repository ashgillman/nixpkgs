{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.11.0";
  sha256 = "0axvyds0gads5914g0m70z5q16gzghr0rk0hy3qjpf1k9bkxvcq6";
})
