{stdenv, buildEnv, fetchFromGitHub, devkitArm, picasso, citro3d, libctru, general-tools }:

#TODO: more general code for multi version

let
	mergedDevkit = buildEnv {
		name = "citro2d-devkit";
		paths = [ devkitArm libctru citro3d ];
	};
in
stdenv.mkDerivation rec {
	pname = "citro2d";
	version = "1.3.1";

	# github release are not up to date
	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "25003e16e90fbe60bf0d019624c7db7b4224f487";
		sha256 = "0m3h775flgzzm7xlwaz007az0qj4v4fgvzxacivsdd69jsirh4hw";
	};


	nativeBuildInputs = [ picasso general-tools ];

  enableParallelBuilding = true;

	prePatch = ''
		substituteInPlace Makefile \
			--replace '$(DESTDIR)$(DEVKITPRO)' $out
	'';
	# render2d_shbin_size is never definied and DVLB_ParseFile doesn't use the second argument:

	DEVKITARM = "${mergedDevkit}/devkitARM";
	DEVKITPRO = "${mergedDevkit}";

}
