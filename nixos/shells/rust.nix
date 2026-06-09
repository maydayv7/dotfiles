pkgs: {
  name = "Rust";
  packages = with pkgs; [
    cargo
    rustup
  ];

  shellHook = ''echo "## Rust Development Shell ##"'';
  RUST_BACKTRACE = 1;
}
