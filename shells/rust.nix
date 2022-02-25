pkgs: {
  name = "Rust";
  packages = with pkgs; [rustup];
  RUST_BACKTRACE = 1;
  shellHook = ''
    echo "## Rust Development Shell ##"

    RUST_DIR="$XDG_DATA_HOME/rust"
    export RUSTUP_HOME="$RUST_DIR/rustup"
    export CARGO_HOME="$RUST_DIR/cargo"
    export PATH=$PATH:"$CARGO_HOME/bin"
  '';
}
