{pkgs ? import <nixpkgs> {}}:

let
	devkit = pkgs.callPackage ./nativePkgs/devkit/devkit.nix {};
in {
	devkitArm = devkit "arm";
	#devkitA64 = devkit "a64";
	#devkitPpc = devkit "ppc";
}
