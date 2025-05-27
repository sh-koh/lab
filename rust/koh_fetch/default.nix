{
  name,
  version,
  src,
  rustPlatform,
}:
rustPlatform.buildRustPackage (_final: {
  inherit name version src;
  nativeBuildInputs = [ ];
  buildInputs = [ ];
  cargoLock.lockFile = ./Cargo.lock;
})
