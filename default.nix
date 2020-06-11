{pkgs ? import <nixpkgs> {}}:

let
	devkit = pkgs.callPackage ./nativePkgs/devkit/devkit.nix {};

	addCFlags = stdenv: cflag: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
        NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " " + cflag;
      });
    };

	addDevkitVariable = stdenv: stdenv //
    { mkDerivation = args: stdenv.mkDerivation (args // {
			#TODO: automatize DEVKITARM and DEVKITPRO
    });
  };

	cross3dsPkgs = pkgs.pkgsCross.arm-embedded;

	cross3dsStdenv = addDevkitVariable (addCFlags
		(pkgs.overrideCC cross3dsPkgs.stdenv devkitArmStandard)
		"-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -O2 -mword-relocations -ffunction-sections -fdata-sections");




	devkitArm = devkit "arm";

	devkitArmStandard = pkgs.stdenv.mkDerivation {
		name = "devkit-arm-standard-architecture";

		phases = [ "installPhase" ];

		installPhase = ''
			mkdir $out
			cp ${devkitArm}/devkitARM/* $out -r -s
		'';
	};
in rec {

	# native
	inherit devkitArm;
	#devkitA64 = devkit "a64";
	#devkitPpc = devkit "ppc";

	general-tools = pkgs.callPackage ./nativePkgs/general-tools/default.nix {};

	picasso = pkgs.callPackage ./nativePkgs/picasso/default.nix {};

	tex3ds = pkgs.callPackage ./nativePkgs/tex3ds/default.nix {};

	_3dstool = pkgs.callPackage ./nativePkgs/3dstool/default.nix {};

	bannertool = pkgs.callPackage ./nativePkgs/bannertool/default.nix {};

	makerom = pkgs.callPackage ./nativePkgs/makerom/default.nix {};

	# library
	library3ds = rec {
		libctru_1_9_0 = pkgs.callPackage ./library/libctru/1_9_0.nix { inherit devkitArm general-tools; };
		libctru = libctru_1_9_0;

		citro3d_1_6_0 = pkgs.callPackage ./library/citro3d/1_6_0.nix { inherit devkitArm libctru; };
		citro3d = citro3d_1_6_0;

		citro2d_1_3_1 = pkgs.callPackage ./library/citro2d/1_3_1.nix { inherit devkitArm picasso libctru citro3d general-tools; };
		citro2d = citro2d_1_3_1;

		bzip2 = (cross3dsPkgs.bzip2.overrideDerivation (old: {
				postPatch = old.postPatch + ''
					substituteInPlace configure.ac \
						--replace "AM_INIT_AUTOMAKE" "AC_NO_EXECUTABLES
						AM_INIT_AUTOMAKE"
					substituteInPlace Makefile.am \
						--replace "bin_PROGRAMS = bzip2 bzip2recover" ""
					aclocal
					automake --add-missing'';
				postInstall = "rm -rf $out/bin";
				nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.automake ];
				outputs = [ "out" ];
				makeFlags = [ "CFLAGS=$(NIX_CFLAGS_COMPILE)" ];
			})).override {stdenv = cross3dsStdenv; linkStatic = true;};
	};

	# homebrew
	homebrew3ds = with library3ds; rec {
		checkpoint = pkgs.callPackage ./homebrew/checkpoint/3ds.nix { inherit devkitArm libctru citro3d citro2d tex3ds bzip2 _3dstool bannertool makerom; } ;
	};

}
