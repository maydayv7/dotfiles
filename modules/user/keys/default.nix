{ config, lib, inputs, ... }:
let
  enable = config.keys.enable;
  gpg = "${inputs.secrets}/gpg";
  ssh = "${inputs.secrets}/ssh";
in rec
{
  options.keys.enable = lib.mkOption
  {
    description = "Enable User Keys Import";
    type = lib.types.bool;
    default = false;
  };

  ## Import User Keys ##
  config = lib.mkIf enable
  {
    # GPG Keys
    home.activation.importGPGKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      echo "Importing GPG Keys..."
      $DRY_RUN_CMD mkdir -p ~/.gnupg $VERBOSE_ARG
      $DRY_RUN_CMD gpg --import ${gpg}/public.gpg $VERBOSE_ARG
      $DRY_RUN_CMD gpg --import ${gpg}/private.gpg $VERBOSE_ARG
    '';

    # SSH Keys
    home.activation.importSSHKeys = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"]
    ''
      FILE=~/.ssh
      if [ -e "$FILE" ];
      then
        echo "SSH Keys already imported"
      else
        echo "Importing SSH Keys..."
        $DRY_RUN_CMD cp ${ssh} ~/.ssh -r $VERBOSE_ARG
        $DRY_RUN_CMD chmod 400 ~/.ssh/id_ed25519
        $DRY_RUN_CMD ssh-add ~/.ssh/id_ed25519
      fi
    '';
  };
}
