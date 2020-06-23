{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
	pname = "doltool";
	version = "master";

	src = fetchFromGitHub {
		owner = "cylgom";
		repo = "doltool";
		rev = "32be47264debdd0d9a9e54a8cc623e04708c3214";
		sha256 = "0y645cg08fbsfjb5q0ii1cqz7mlblq6my2s55p3ckaz7kzq6v948";
	};

	makeFlags = [ "PREFIX=$(out)/bin" ];

	prePatch = ''
		substituteInPlace makefile \
			--replace "LDFLAGS += -static" ""
	'';

	preInstall = ''
		mkdir -p $out/bin
	'';

	enableParallelBuilding = true;
}
