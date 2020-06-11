{stdenv, fetchFromGitHub, devkitArm, general-tools }:

#TODO: more general code for multi version

stdenv.mkDerivation rec {
	pname = "libctru";
	version = "1.9.0";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "1caqrk5rgh007jh5asaf4pddakzwlldscqp41fqbvdhssvbp9dd1";
	};

	nativeBuildInputs = [ general-tools ];

	enableParallelBuilding = true;

	prePatch = ''
		cd libctru
		substituteInPlace Makefile \
			--replace '$(DESTDIR)$(DEVKITPRO)' $out
	'';

	DEVKITARM = "${devkitArm}/devkitARM";
	DEVKITPRO = "${devkitArm}";

}
