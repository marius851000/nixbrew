{pkgs ? import <nixpkgs> {}}:

let
	devkit = pkgs.callPackage ./nativePkgs/devkit/devkit.nix {};
in {
	devkitarm = devkit "arm";
	#devkita64 = devkit "a64";
	#devkitppc = devkit "ppc";
}
