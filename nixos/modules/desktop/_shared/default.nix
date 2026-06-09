{
  util ? null,
  files ? null,
  inputs ? null,
  ...
}: {lib, ...}: {
  options._shared.enable = lib.mkEnableOption "INTERNAL: Enable Shared Configuration";
  imports = [
    (import ./browser.nix {inherit util files inputs;})
    (import ./files.nix {inherit util files inputs;})
    (import ./login.nix {inherit util files inputs;})
    (import ./media.nix {inherit util files inputs;})
    (import ./misc.nix {inherit util files inputs;})
    (import ./notify.nix {inherit util files inputs;})
    (import ./panel.nix {inherit util files inputs;})
    (import ./security.nix {inherit util files inputs;})
    (import ./style.nix {inherit util files inputs;})
    (import ./terminal.nix {inherit util files inputs;})
    (import ./text.nix {inherit util files inputs;})
    (import ./theme.nix {inherit util files inputs;})
    (import ./utilities.nix {inherit util files inputs;})
  ];
}
