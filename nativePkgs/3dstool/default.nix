{stdenv, fetchFromGitHub, autoreconfHook}:

stdenv.mkDerivation rec {
	pname = "3dstools";
	version = "1.1.4";

	src = fetchFromGitHub {
		owner = "devkitPro";
		repo = pname;
		rev = "v${version}";
		sha256 = "15zj6l2wlzp3xcxr7lxd50nqzj0z58q7qrfc44frhxgaymzgv839";
	};

	nativeBuildInputs = [ autoreconfHook ];
}
