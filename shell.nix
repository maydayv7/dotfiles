(import (let lock = builtins.fromJSON (builtins.readFile ./flake.lock);
in fetchTarball {
  url =
    "https://github.com/edolstra/flake-compat/archive/${lock.nodes.compatibility.locked.rev}.tar.gz";
  sha256 = lock.nodes.compatibility.locked.narHash;
}) { src = ./.; }).shellNix
