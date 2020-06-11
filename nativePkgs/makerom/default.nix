{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
	pname = "makerom";
	version = "0.17";

	src = fetchFromGitHub {
		owner = "3DSGuy";
		repo = "Project_CTR";
		rev = "${pname}-v${version}";
		sha256 = "0vg7bzkfnkl6mxcibnja4fxk5ljh2g3qgkdww373idj32i3r55qg";
	};

	prePatch = "cd makerom";

	installPhase = ''
		mkdir -p $out/bin
		cp makerom $out/bin
	'';
	
	enableParallelBuilding = true;
}
