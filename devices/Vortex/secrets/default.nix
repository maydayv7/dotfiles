{util, ...}: {
  ## System Secrets ##
  config.sops.secrets = util.map.secrets ./. false;
}
