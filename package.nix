{
  pkgs,
  stdenv,
  ...
}:
let
  systemToReleaseABINameMap = {
    "x86_64-linux" = "x86_64-unknown-linux-gnu";
    "aarch64-linux" = "aarch64-unknown-linux-gnu";
    "aarch64-darwin" = "aarch64-apple-darwin";
  };
  # The SHA256 hashes for the IronClaw releases for each platform. Update these when a new release is made.
  sha256Map = {
    "x86_64-linux" = "sha256:027vi6w61wsnmip1xmpcc0nlmb0km9h8zs26ip28s0rspb06lcxg";
    "aarch64-linux" = "sha256:151qlc5mfchzzracky2wflzvdj7nip52cm3my46yv0292gk03c37";
    "aarch64-darwin" = "sha256:0pgpawkadgizs8kkl0l6zcn8jiclnd74frdk14bh09by2sj00jcl";
  };
  # The version of IronClaw to package. Update this when a new release is made.
  version = "0.16.1";
  # The system for which to fetch the release. This is determined dynamically based on the host platform.
  system = stdenv.hostPlatform.system;
  src = fetchTarball {
    url = "https://github.com/nearai/ironclaw/releases/download/v${version}/ironclaw-${
      systemToReleaseABINameMap.${system}
    }.tar.gz";
    sha256 = sha256Map.${system};
  };
in
stdenv.mkDerivation {
  name = "ironclaw";
  inherit version src;
  nativeBuildInputs = [
    pkgs.autoPatchelfHook
  ];
  buildInputs = [
    pkgs.openssl
    stdenv.cc.cc.lib
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/ironclaw $out/bin
    chmod +rwx $out/bin/ironclaw
  '';
}
