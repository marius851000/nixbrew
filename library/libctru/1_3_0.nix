{stdenv, fetchFromGitHub, devkitArm, general-tools }:

#TODO: more general code for multi version

stdenv.mkDerivation rec {
	pname = "libctru";
	version = "1.3.0";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "078dj1z8abn72fb0n6grdgl1rw7laj4313ppvcp8swx30rl169s0";
	};

	nativeBuildInputs = [ general-tools ];

	enableParallelBuilding = true;

	ERROR_FILTER = "-Wno-stringop-truncation -Wno-stringop-overflow -Wno-format-overflow";

	prePatch = ''
		cd libctru
		substituteInPlace Makefile \
			--replace '$(DEVKITPRO)/libctru' $out/libctru
	'';

	DEVKITARM = "${devkitArm}/devkitARM";
	DEVKITPRO = "${devkitArm}";

}
