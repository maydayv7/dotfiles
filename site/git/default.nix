{
  lib,
  pkgs,
  site ? "https://git.maydayv7.dev",
  sitename ? "maydayv7",
  test ? false,
}: let
  stagit = pkgs.callPackage ./stagit {};
  assets = pkgs.callPackage ./assets.nix {gitSite = site;};
  buildCommands =
    if test
    then ''build_repo test "A long description just for testing" Me "$(pwd)"''
    else
      lib.concatMapStrings (repo: ''
        build_repo ${lib.escapeShellArgs [repo.name repo.description repo.owner repo.url]}
      '') (import ./repos.nix);
in
  pkgs.writeShellApplication {
    name = "gitsite";
    runtimeInputs = with pkgs; [
      coreutils
      git
      stagit
      (python3.withPackages (ps: [ps.fonttools ps.brotli ps.lxml]))
    ];
    text = ''
      # Build Directory
      OUTPUT_DIR=$(realpath -m "''${1:-./public}")
      if [ -e "$OUTPUT_DIR" ]
      then
        echo "Output already exists: $OUTPUT_DIR. Choose an empty destination." >&2
        exit 1
      fi
      mkdir -p "$(dirname "$OUTPUT_DIR")"
      BUILD_ROOT=$(mktemp -d "$(dirname "$OUTPUT_DIR")/.stagit-build.XXXXXXXX")
      trap 'rm -rf "$BUILD_ROOT"' EXIT
      STAGING_DIR="$BUILD_ROOT/public"
      export TZ=UTC
      mkdir -p "$STAGING_DIR" "$BUILD_ROOT/repos"

      build_repo() {
        local name=$1 description=$2 owner=$3 url=$4
        local repository="$BUILD_ROOT/repos/$name.git"
        echo "Building $name..."

        # Repository
        git -c safe.directory="$url" -c safe.directory="$url/.git" \
          -c http.lowSpeedLimit=1024 -c http.lowSpeedTime=60 clone --bare "$url" "$repository"
        printf '%s\n' "$description" > "$repository/description"
        printf '%s\n' "$owner" > "$repository/owner"
        printf '%s\n' "$url" > "$repository/url"
        mkdir -p "$STAGING_DIR/$name"
        (cd "$STAGING_DIR/$name" && stagit -l 50 -n ${lib.escapeShellArg sitename} \
          -u ${lib.escapeShellArg site}/"$name" "$repository")
      }

      if [ "$#" -gt 1 ]
      then
        LOCAL_REPO=$(realpath "$2")
        build_repo "$(basename "$LOCAL_REPO" .git)" "Local preview" ${lib.escapeShellArg sitename} "$LOCAL_REPO"
      else
        ${buildCommands}
      fi

      stagit-index -n ${lib.escapeShellArg sitename} "$BUILD_ROOT/repos/"*.git > "$STAGING_DIR/index.html"
      python3 ${./assemble.py} assemble "$STAGING_DIR" ${assets} --repositories "$BUILD_ROOT/repos"
      cp -r ${assets}/. "$STAGING_DIR/"
      chmod -R u+w "$STAGING_DIR"
      rm "$STAGING_DIR/shell.html"
      cp ${./_headers} "$STAGING_DIR/_headers"
      python3 ${../scripts/optimize_fonts.py} "$STAGING_DIR" --source ${../static/fonts}
      mv "$STAGING_DIR" "$OUTPUT_DIR"
      echo "Built gitsite at $OUTPUT_DIR"
    '';
    meta = {
      mainProgram = "gitsite";
      description = "Build the gitsite";
      license = lib.licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
