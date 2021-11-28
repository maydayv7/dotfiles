let
  # SSH Key
  key = builtins.readFile ../keys/ssh_key.pub;
in
{
  # User Passwords
  "passwords/root.age".publicKeys = [ key ];
  "passwords/v7.age".publicKeys = [ key ];
  "passwords/navya.age".publicKeys = [ key ];

  # GPG Keys
  "gpg/public.gpg.age".publicKeys = [ key ];
  "gpg/private.gpg.age".publicKeys = [ key ];
}
