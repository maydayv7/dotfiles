pkgs: {
  name = "Java";
  packages = with pkgs; [jdk nodejs scala sbt yarn];
  shellHook = ''
    echo "## Java Development Shell ##"

    NPM_DIR="$XDG_DATA_HOME/npm"
    mkdir "$NPM_DIR"
    echo -e "cache=$XDG_CACHE_HOME/npm\nprefix=$XDG_DATA_HOME/npm" > "$NPM_DIR/config"
    export NPM_CONFIG_USERCONFIG="$NPM_DIR/config"
    export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
    export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"
    export NPM_CONFIG_PREFIX="$XDG_CACHE_HOME/npm"
    export NODE_REPL_HISTORY="$XDG_CACHE_HOME/node/repl_history"
    export PATH=$PATH:"$(yarn global bin)"
  '';
}
