{ inputs, ... }:
{
  ## Authentication Credentials ##
  # User Passwords
  root = (builtins.readFile "${inputs.secrets}/passwords/root");
  v7 = (builtins.readFile "${inputs.secrets}/passwords/v7");
  navya = (builtins.readFile "${inputs.secrets}/passwords/navya");

  # Keys
  github = (builtins.readFile "${inputs.secrets}/github/token");
  ssh.path = "${inputs.secrets}/ssh";
  gpg =
  {
    path = "${inputs.secrets}/gpg";
    key = (builtins.readFile "${inputs.secrets}/gpg/key");
  };
}
