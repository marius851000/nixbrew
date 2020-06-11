{stdenv, fetchgit, zip}:

stdenv.mkDerivation rec {
	pname = "bannertool";
	version = "1.2.0";

	#for submodules
	src = fetchgit {
		url = "https://github.com/Steveice10/bannertool.git";
		rev = version;
		sha256 = "12zj8mgw8wbd1hnfjcr6lg2pr1nzpmid4zhnka1ykvp382yj2bml";
	};

	postPatch = ''
		substituteInPlace buildtools/make_base \
			--replace /usr/local/bin $out/bin
	'';

	preInstall = ''
		mkdir -p $out/bin
	'';

	nativeBuildInputs = [ zip ];

	enableParallelBuilding = true;
}
