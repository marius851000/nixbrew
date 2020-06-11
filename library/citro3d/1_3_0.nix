{stdenv, fetchFromGitHub, devkitArm, libctru_1_3_0, buildEnv }:

#TODO: more general code for multi version

let
	mergedDevkit = buildEnv {
		name = "citro3d-devkit";
		paths = [ devkitArm libctru_1_3_0 ];
	};
in
stdenv.mkDerivation rec {
	pname = "citro3d";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "17wgi7jmbgbh5aqnc67ckiqbf8pfxfajvajyksrj9v42ck03c5ab";
	};

  enableParallelBuilding = true;

	prePatch = ''
		substituteInPlace Makefile \
			--replace '$(DEVKITPRO)/libctru' $out/libctru
	'';

	DEVKITARM = "${mergedDevkit}/devkitARM";
	DEVKITPRO = "${mergedDevkit}";

}
