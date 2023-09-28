{lib, ...}: {
  ## System Secrets ##
  config.sops.secrets = lib.util.map.secrets ./. false;
}
