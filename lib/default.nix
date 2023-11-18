args:
(import ./map.nix args).modules ./. (file: import file args)
