{stdenv, fetchFromGitHub, automake, autoconf}:

stdenv.mkDerivation rec {
	pname = "general-tools";
	version = "1.0.3";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = "general-tools";
		rev = "v${version}";
		sha256 = "1030269qwcndaygwkakv54g0gnw4w4qngwg4zy5a2j1a2dl4l6sp";
	};

	enableParallelBuilding = true;

	preConfigure = "./autogen.sh";

	nativeBuildInputs = [ automake autoconf ];
}
