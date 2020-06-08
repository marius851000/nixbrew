{ stdenv, fetchFromGitHub, which, gmp, mpfr, libmpc, zlib }:
with builtins;

let
	version = "20201105";
	srcs = {
		buildscripts = fetchFromGitHub {
			owner = "devkitPro";
			repo = "buildscripts";
			rev = "v${version}";
			sha256 = "1w0b4rhpsxcqw8ni47ajq514ghn3526r35b0rxlcba4pzf95jf25";
		};
		devkitarm_rules_1_0_0 = fetchurl {
			url = "https://downloads.devkitpro.org/devkitarm-rules-1.0.0.tar.xz";
			sha256 = "0w7sasydlvpz5m0v0k15kwck7b9qv6zx1m3frajcnw6siv353b8h";
		};
		devkitarm_crtls_1_0_0 = fetchurl {
			url = "https://downloads.devkitpro.org/devkitarm-crtls-1.0.0.tar.xz";
			sha256 = "0g348prjbp8yvbrmwqmznbbd6w1jrqp2x2vb8zfkr6lh11m2z2yv";
		};
		binutils_2_32 = fetchurl {
			url = "https://downloads.devkitpro.org/binutils-2.32.tar.xz";
			sha256 = "017ffgj3d2rfr13692bzamsrz2qanywibfkj35bfv4kav1fwbdha";
		};
		gcc_10_1_0 = fetchurl {
			url = "https://downloads.devkitpro.org/gcc-10.1.0.tar.xz";
			sha256 = "18kyds3ss4j7in8shlsbmjafdhin400mq739d0dnyrabhhiqm2dn";
		};
		newlib_3_3_0 = fetchurl {
			url = "https://downloads.devkitpro.org/newlib-3.3.0.tar.gz";
			sha256 = "0ricyx792ig2cb2x31b653yb7w7f7mf2111dv5h96lfzmqz9xpaq";
		};
		gdb_8_2_1 = fetchurl {
			url = "https://downloads.devkitpro.org/gdb-8.2.1.tar.xz";
			sha256 = "04kicy7awvvk1li3n2l024gdbcy943h3h0bgslzpx93b08lbpams";
		};
	};

	getArchitectureId = architecture: (
		if (architecture == "arm") then "1"
		else if (architecture == "ppc") then "2"
		else if (architecture == "a64") then "3"
		else "architecture not supported"
	);

	compileFile = architecture: builtins.toFile "config.sh" ''
		BUILD_DKPRO_PACKAGE=${getArchitectureId architecture}
		BUILD_DKPRO_INSTALLDIR=$out
		BUILD_DKPRO_AUTOMATED=1
	'';
in
architecture: stdenv.mkDerivation {
	pname = "devkit-${architecture}";
	version = version;
	src = srcs.buildscripts;

	#DESTDIR = "$out"

	nativeBuildInputs = [ which ];

	buildInputs = [ gmp mpfr libmpc zlib ];

	patches = [
		./devkit-offline.diff
		./patch.diff
	];

	postPatch = (if (architecture == "arm") then (''
		cp ${srcs.devkitarm_rules_1_0_0} devkitarm-rules-1.0.0.tar.xz
		cp ${srcs.devkitarm_crtls_1_0_0} devkitarm-crtls-1.0.0.tar.xz
		cp ${srcs.binutils_2_32} binutils-2.32.tar.xz
		cp ${srcs.gcc_10_1_0} gcc-10.1.0.tar.xz
		cp ${srcs.newlib_3_3_0} newlib-3.3.0.tar.gz
		cp ${srcs.gdb_8_2_1} gdb-8.2.1.tar.xz
		cp ${./crlts_arm_makefile_install.diff} crlts_arm_makefile_install.diff
		cp ${./rules_arm_makefile_install.diff} rules_arm_makefile_install.diff
	'') else "");

	postConfigure = ''
		cp ${compileFile architecture} ./config.sh
	'';

	buildPhase = ''
		sh build-devkit.sh
	'';
}
