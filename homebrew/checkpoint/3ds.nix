{stdenv, fetchgit, devkitArm, libctru, citro3d, citro2d, buildEnv, python3, tex3ds,
	bzip2, _3dstool, bannertool}:
#TODO: switch version
#TODO: finish
let
	mergedDevkit = buildEnv {
		name = "checkpoint-3ds-devkit";
		paths = [ devkitArm libctru citro3d citro2d ];
	};
in
stdenv.mkDerivation rec {
	pname = "Checkpoint";
	version = "3.7.4";

	#for submodules
	src = fetchgit {
		url = "https://github.com/FlagBrew/Checkpoint.git";
		rev = "v${version}";
		sha256 = "09kkligcx45gmm2vwr6n9vmx1pqf6n0qk04209qsqgdx64pj6wb2";
	};

	nativeBuildInputs = [ python3 tex3ds _3dstool bannertool ];

	buildInputs = [ bzip2 ];

	enableParallelBuilding = true;

	postPatch = ''
		substituteInPlace Makefile \
			--replace "@make --always-make -C switch cheats" ""
	''; #TODO: upstream patch

	makeFlags = [ "3ds" "PORTLIBS=${bzip2}" ];

	DEVKITARM = "${mergedDevkit}/devkitARM";
	DEVKITPRO = "${mergedDevkit}";
}
