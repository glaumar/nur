# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> {
    config.android_sdk.accept_license = true;
    config.allowUnfree = true;
  }
}:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  example-package = pkgs.callPackage ./pkgs/example-package { };

  qrookie =
    let
      buildToolsVersion = "34.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [ buildToolsVersion ];
      };
      zipAlignPath = "${androidComposition.androidsdk}/libexec/android-sdk/build-tools/${buildToolsVersion}";
    in
    pkgs.callPackage ./pkgs/qrookie { inherit zipAlignPath; };
  # some-qt5-package = pkgs.libsForQt5.callPackage ./pkgs/some-qt5-package { };
  # ...
}
