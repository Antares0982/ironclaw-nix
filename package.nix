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
    "x86_64-linux" = "sha256:126ksw01b3qrhhnkbgk80j8azf661y2cb9c2g2rqyn6pnkqw5pj6";
    "aarch64-linux" = "sha256:170cdgzyrpib3bj5wjk8p9nsc6s441dz0kp7m8689c74mkfyg7p0";
    "aarch64-darwin" = "sha256:0s8ia0by68rgxgkssxsqw6xh4axvi6qxdasjcicqa7x5kvyhh08g";
  };
  # The version of IronClaw to package. Update this when a new release is made.
  version = "0.15.0";
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
