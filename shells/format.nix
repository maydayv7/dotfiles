pkgs: {
  name = "Formatter";
  shellHook = ''echo "## Formatting Shell ##"'';
  packages = with pkgs; [
    unstable.alejandra
    nix-linter
    nodePackages.prettier
    shellcheck
    statix
  ];
}
