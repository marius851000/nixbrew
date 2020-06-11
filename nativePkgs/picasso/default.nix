{stdenv, fetchFromGitHub, automake, autoconf}:

stdenv.mkDerivation rec {
	pname = "picasso";
	version = "2.7.0";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = "picasso";
		rev = "v${version}";
		sha256 = "0mky502mkmky5b3z1z0ylbajbw5rzamm9kayqv7khifx2m2ih855";
	};

	enableParallelBuilding = true;
	
	preConfigure = "./autogen.sh";

	nativeBuildInputs = [ automake autoconf ];
}
