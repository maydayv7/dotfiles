{ system, lib, inputs, pkgs, scripts, custom, ... }:
{
  overlays =
  [
    # Unstable Packages Overlay
    (final: prev: { unstable = inputs.unstable.legacyPackages.x86_64-linux; })
    
    # Nix User Repository Overlay
    inputs.nur.overlay
    
    # System Scripts Overlay
    scripts.overlay
    
    # Package Overlays
    # If you don't know the hash for package source, set:
    # sha256 = "0000000000000000000000000000000000000000000000000000";
    # Then Nix will fail the build with an error message and give the sha256 in base64
    # Use nix hash to-base32 'sha256-hash' to compute the right hash
    (final: prev:
    {
      # GNOME Shell Extension Dash to Panel - Personal Fork
      # https://github.com/maydayv7/gnome-panel
      gnomeExtensions = prev.gnomeExtensions //
      {
        dash-to-panel = lib.overrideDerivation prev.gnomeExtensions.dash-to-panel (drv:
        {
          src = inputs.gnome-panel;
        });
      };
      
      # Latest Plymouth built from master - Personal Fork
      # https://gitlab.freedesktop.org/plymouth/plymouth
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
      
      # Latest SOF-Firmware v1.8
      # https://github.com/NixOS/nixpkgs/pull/130884
      sof-firmware = prev.sof-firmware.overrideAttrs (old:
      {
        version = "1.8";
        
        src = prev.fetchFromGitHub
        {
          owner = "thesofproject";
          repo = "sof-bin";
          rev = "v1.8";
          sha256 = "NPbzDXZoZVWriV3klemX59ACnAlb357A5V/GbmzshyA=";
        };
        
        installPhase =
        ''
          cd v1.8.x
          mkdir -p $out/lib/firmware/intel/
          cp -a sof-v1.8 $out/lib/firmware/intel/sof
          cp -a sof-tplg-v1.8 $out/lib/firmware/intel/sof-tplg
        '';
      });
      
      # Custom Packages
      inherit custom;
    })
  ];
}
