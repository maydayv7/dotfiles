{
  lib,
  inputs,
  ...
}: {
  ## Nix Registry ##
  config = {
    nix = {
      nixPath = ["/etc/nix/inputs"];
      registry =
        builtins.mapAttrs (_: value: {flake = value;})
        (lib.filterAttrs (_: value: value ? outputs) inputs);
    };

    environment.etc =
      lib.mapAttrs'
      (name: value: {
        name = "nix/inputs/${name}";
        value = {source = value.outPath;};
      })
      inputs;
  };
}
