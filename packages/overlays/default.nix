{ system, lib, inputs, pkgs, custom, ... }:
{
  ## System Package Overlays ##
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
      # GNOME Shell Extension Dash to Panel
      # https://github.com/home-sweet-gnome/dash-to-panel
      gnomeExtensions = prev.gnomeExtensions //
      {
        dash-to-panel = lib.overrideDerivation prev.gnomeExtensions.dash-to-panel (drv:
        {
          src = inputs.gnome-panel;
        });
      };

      # Latest Plymouth built from master
      # https://github.com/freedesktop/plymouth
      plymouth = prev.plymouth.overrideAttrs (old:
      {
        src = inputs.plymouth;
        patches = [];
      });

      # Latest dconf2nix built from master
      # https://github.com/gvolpe/dconf2nix
      dconf2nix = prev.dconf2nix.overrideAttrs (old:
      {
        src = inputs.dconf;
      });

      # GNOME Terminal Transparency Patch
      # https://aur.archlinux.org/packages/gnome-terminal-transparency
      gnome = prev.gnome //
      {
        gnome-terminal = lib.overrideDerivation prev.gnome.gnome-terminal (drv:
        {
          patches = drv.patches ++ [ ../sources/transparency.patch ];
        });
      };

      # Patch Google Chrome Dark Mode
      google-chrome = prev.google-chrome.overrideAttrs (old:
      {
        installPhase = old.installPhase +
        ''
          exe=$out/bin/google-chrome-stable
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
