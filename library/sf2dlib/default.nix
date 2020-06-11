{stdenv, fetchFromGitHub, devkitArm, buildEnv, libctru, citro3d_1_3_0, picasso, general-tools }:



let
	mergedDevkit = buildEnv {
		name = "sf2dlib-devkit";
		paths = [ devkitArm libctru citro3d_1_3_0 ];
	};
in
stdenv.mkDerivation rec {
	pname = "sf2dlib";
	version = "master";

	src = fetchFromGitHub {
		owner = "TricksterGuy";
		repo = pname;
		rev = "ce6f18e81176e9f9703b70d95ce1aa15a948c93d";
		sha256 = "190ihnxkfzilg2wfpaz5psifhdnbj58nclff9dpshvp645p09k8b";
	};

  enableParallelBuilding = false;

	nativeBuildInputs = [ picasso general-tools ];
	prePatch = ''
		cd libsf2d
		substituteInPlace Makefile \
			--replace '$(CTRULIB)/lib' $out/libctru/lib \
			--replace '$(CTRULIB)/include' $out/libctru/include
	'';

	preInstall = ''
		mkdir -p $out/libctru/lib $out/libctru/include
	'';

	DEVKITARM = "${mergedDevkit}/devkitARM";
	DEVKITPRO = "${mergedDevkit}";

}
