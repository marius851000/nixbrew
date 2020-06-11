{stdenv, fetchFromGitHub, devkitArm, libctru, buildEnv }:

#TODO: more general code for multi version

let
	mergedDevkit = buildEnv {
		name = "citro3d-devkit";
		paths = [ devkitArm libctru ];
	};
in
stdenv.mkDerivation rec {
	pname = "citro3d";
	version = "1.6.0";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "0zxp32ik21y67dwsssx4z3hrrwcbwx9m0q56fv54059z9xffwxyx";
	};

  enableParallelBuilding = true;

	prePatch = ''
		substituteInPlace Makefile \
			--replace '$(DESTDIR)$(DEVKITPRO)' $out
	'';

	DEVKITARM = "${mergedDevkit}/devkitARM";
	DEVKITPRO = "${mergedDevkit}";

}
