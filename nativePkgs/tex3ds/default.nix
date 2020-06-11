{stdenv, fetchFromGitHub, autoconf, automake, pkg-config, freetype, imagemagick }:

stdenv.mkDerivation rec {
	pname = "tex3ds";
	version = "2.0.1";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "1d0ncjdyx2dry57188gj2gsn8bwkpmb7aapmxh4fp1b3llqd315p";
	};

	nativeBuildInputs = [ autoconf automake pkg-config imagemagick];

	buildInputs = [ freetype ];
	preConfigure = "./autogen.sh";
}
