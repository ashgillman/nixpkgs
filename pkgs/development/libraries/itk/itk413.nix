{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "4.13.0";
  sha256 = "09d1gmqx3wbdfgwf7r91r12m2vknviv0i8wxwh2q9w1vrpizrczy";
})
