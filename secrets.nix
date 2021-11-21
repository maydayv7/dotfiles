{ inputs, ... }:
let
  inherit (builtins) readFile;
in
{
  ## Authentication Credentials ##
  # User Passwords
  root = readFile "${inputs.secrets}/passwords/root";
  v7 = readFile "${inputs.secrets}/passwords/v7";
  navya = readFile "${inputs.secrets}/passwords/navya";

  # Keys
  github = readFile "${inputs.secrets}/github/token";
  ssh.path = "${inputs.secrets}/ssh";
  gpg =
  {
    path = "${inputs.secrets}/gpg";
    key = readFile "${inputs.secrets}/gpg/key";
  };
}
