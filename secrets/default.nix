{ inputs, ... }:
{
  ## Authentication Credentials ##
  # User Passwords
  root = (builtins.readFile "${inputs.secrets}/passwords/root");
  v7 = (builtins.readFile "${inputs.secrets}/passwords/v7");
  navya = (builtins.readFile "${inputs.secrets}/passwords/navya");

  # Keys
  github = (builtins.readFile "${inputs.secrets}/github/token");
  gpg = "${inputs.secrets}/gpg";
  ssh = "${inputs.secrets}/ssh";
}
