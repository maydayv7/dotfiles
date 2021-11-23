{ system, lib, inputs, pkgs, custom, ... }:
{
  ## Overrides for Pre-Built Packages ##
  overlays =
  [
    # Unstable Packages Enablement
    (final: prev: { unstable = inputs.unstable.legacyPackages."${system}"; })

    # Nix User Repository Enablement
    inputs.nur.overlay

    ## Package Overrides ##
    # It is advisable to use Flake inputs as the source for overriden packages
    # To pin a package revision add '?rev=' after the input url
    # Else you may also specify the package source using fetch
    # In case you don't know the hash for the source, set:
    # sha256 = "0000000000000000000000000000000000000000000000000000";
    # Then Nix will fail the build with an error message and give the correct sha256 in base64
    # Use nix hash to-base32 'sha256-hash' to compute the right hash
    (final: prev:
    {
      # GNOME Terminal Transparency Patch
      # https://aur.archlinux.org/packages/gnome-terminal-transparency
      gnome = prev.gnome //
      {
        gnome-terminal = lib.overrideDerivation prev.gnome.gnome-terminal (drv:
        {
          patches = drv.patches ++
          [ (prev.fetchpatch
            {
              url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency&id=7dd7cd2471e42af8130cda7905b2b2c2a334ac4b";
              sha256 = "0y116dww3j1mk4s2qklkgw8jjmvdfdpwynbijq0iwazvlggmsilk";
              name = "transparency.patch";
            })
          ];
        });
      };

      # Patch Google Chrome Dark Mode
      google-chrome = prev.google-chrome.overrideAttrs (old:
      {
        installPhase = old.installPhase +
        ''
          fix=" --enable-features=WebUIDarkMode --force-dark-mode"

          substituteInPlace $out/share/applications/google-chrome.desktop \
            --replace $exe "$exe$fix"
        '';
      });

      # Custom Packages
      inherit custom;
    })
  ];
}
