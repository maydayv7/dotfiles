{
  lib,
  pkgs,
  gitSite ? null,
}: let
  mainSite = (fromTOML (builtins.readFile ../zola.toml)).base_url;
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "gitsite-assets";
    version = "1";
    src = ../.;
    nativeBuildInputs = [
      pkgs.zola
      (pkgs.python3.withPackages (ps: [ps.lxml]))
    ];
    buildPhase = ''
      runHook preBuild
      cat > content/git-shell.md <<'EOF'
      +++
      template = "git-shell.html"
      in_search_index = false
      +++
      EOF
      ${lib.optionalString (gitSite != null) ''
        substituteInPlace zola.toml --replace-fail 'https://git.maydayv7.dev' ${lib.escapeShellArg gitSite}
      ''}
      zola build
      runHook postBuild
    '';
    installPhase = ''
      python3 git/assemble.py export public "$out" --base-url ${lib.escapeShellArg mainSite}
    '';
  }
