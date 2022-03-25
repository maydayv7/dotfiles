let
  flake = import (let
    lock =
      (builtins.fromJSON
        (builtins.readFile ../../flake.lock))
      .nodes
      .compatibility
      .locked;
  in
    fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    }) {src = ../../.;};
in
  flake
