{pkgs}: let
  python = pkgs.python3.withPackages (ps:
    with ps; [
      pygments
      nh3
      markdown
      pymdown-extensions
      (buildPythonPackage rec {
        pname = "markdown_callouts";
        version = "0.4.0";
        pyproject = true;
        build-system = [hatchling];
        dependencies = [markdown];
        src = fetchPypi {
          inherit pname version;
          hash = "sha256-ftLJBIaWcFinOlR3gRIZg4OVItZwQa5SxJeWFvGyt0Y=";
        };
      })
    ]);
in
  pkgs.stdenv.mkDerivation {
    pname = "stagit";
    version = "1.2-custom";
    src = ./.;
    buildInputs = [pkgs.libgit2];
    nativeBuildInputs = [pkgs.makeWrapper];
    makeFlags = [
      "PREFIX=$(out)"
      "STAGIT_CFLAGS=-I${pkgs.libgit2.dev}/include"
      "STAGIT_LDFLAGS=-lgit2"
    ];
    postInstall = ''
      sed -i '1c #!${python}/bin/python3' "$out/bin/render"
      wrapProgram "$out/bin/stagit" --prefix PATH : "$out/bin"
    '';
    meta.mainProgram = "stagit";
  }
