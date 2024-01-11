pkgs: {
  name = "SQL";
  buildInputs = [pkgs.mariadb];
  shellHook = ''
    MYSQL_BASEDIR=${pkgs.mariadb}
    MYSQL_HOME=$HOME/.mysql
    MYSQL_DATADIR=$MYSQL_HOME/data
    export MYSQL_UNIX_PORT=$MYSQL_HOME/mysql.sock
    MYSQL_PID_FILE=$MYSQL_HOME/mysql.pid
    alias mysql='mysql -u root'

    if [ ! -d "$MYSQL_HOME" ]; then
      # Make sure to use normal authentication method otherwise we can only
      # connect with unix account, but users do not actually exist in NixOS
      mysql_install_db --auth-root-authentication-method=normal \
        --datadir=$MYSQL_DATADIR --basedir=$MYSQL_BASEDIR \
        --pid-file=$MYSQL_PID_FILE
    fi

    # Starts the daemon
    mysqld --datadir=$MYSQL_DATADIR --pid-file=$MYSQL_PID_FILE \
      --socket=$MYSQL_UNIX_PORT 2> $MYSQL_HOME/mysql.log &
    MYSQL_PID=$!

    finish() {
      mysqladmin -u root --socket=$MYSQL_UNIX_PORT shutdown
      kill $MYSQL_PID
      wait $MYSQL_PID
    }
    trap finish EXIT
  '';
}
