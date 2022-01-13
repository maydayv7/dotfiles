(import
  (let inputs = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes;
  in fetchTarball {
    url =
      "https://github.com/edolstra/flake-compat/archive/${inputs.compatibility.locked.rev}.tar.gz";
    sha256 = inputs.compatibility.locked.narHash;
  }) { src = ./.; }).defaultNix
