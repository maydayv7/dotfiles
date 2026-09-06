{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  name = "Website";
  packages = with pkgs; [
    git
    zola
    wrangler
    (python3.withPackages (python: [python.fonttools python.brotli]))
  ];
  shellHook = ''echo "## Website Builder Shell ##"'';
}
