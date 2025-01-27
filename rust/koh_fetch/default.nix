{
  name,
  version,
  src,
  rustPlatform,
}:
rustPlatform.buildRustPackage (final: {
  inherit name version src;
  nativeBuildInputs = [ ];
  buildInputs = [ ];
  cargoLock.lockFile = ./Cargo.lock;
})
