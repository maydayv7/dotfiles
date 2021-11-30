let
  # SSH Key
  key = builtins.readFile ../keys/ssh_key.pub;
in
{
  # Github TOken
  "github/token.age".publicKeys = [ key ];

  # Cachix Token
  "cachix/token.age".publicKeys = [ key ];

  # GPG Keys
  "gpg/public.gpg.age".publicKeys = [ key ];
  "gpg/private.gpg.age".publicKeys = [ key ];

  # User Passwords
  "passwords/root.age".publicKeys = [ key ];
  "passwords/v7.age".publicKeys = [ key ];
  "passwords/navya.age".publicKeys = [ key ];
}
