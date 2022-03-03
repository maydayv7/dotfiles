{pkgs ? import ../., ...}:
pkgs.mkShell {
  name = "Website";
  packages = with pkgs; [git zola lorri];
  shellHook = ''echo "## Website Builder Shell ##"'';
}
