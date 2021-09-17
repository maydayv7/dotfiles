# Overlay for latest Plymouth
# https://gitlab.freedesktop.org/plymouth/plymouth
self: super:
{
  plymouth = super.plymouth.overrideAttrs (old: {
    src = super.fetchFromGitLab
    {
      domain = "gitlab.freedesktop.org";
      owner = "plymouth";
      repo = "plymouth";
      rev = "e55447500fa95a0cc59c741296030ed91a2986dc";
      sha256 = "1b319b2da1ypkri7zvd9yzq8v37w149g3jmsjz8prhfjgw7xgknd";
    };
      
     patches = [];
  });
}
