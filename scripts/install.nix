{
  lib,
  pkgs,
  files,
  ...
}:
with files.path; let
  inherit (lib) licenses recursiveUpdate;
in
  recursiveUpdate
  {
    meta = {
      mainProgram = "os-install";
      description = "System Install Script";
      homepage = repo;
      license = licenses.gpl3Only;
      maintainers = ["maydayv7"];
    };
  }
  (
    pkgs.writeShellApplication {
      name = "os-install";
      runtimeInputs = with pkgs; [
        coreutils
        disko.disko
        git
        gptfdisk
        netcat
        nixFlakes
        nixos-install-tools
        util-linux
        zfs
      ];

      text = ''
        set -euo pipefail
        ${files.scripts.commands}

        TRIES=5
        CLEAN_TARGET=false

        cleanup() {
          if [ "$CLEAN_TARGET" = true ]
          then
            umount -R /mnt 2> /dev/null || true
            zpool export fspool 2> /dev/null || true
            CLEAN_TARGET=false
          fi
        }

        trap cleanup EXIT

        install_system() {
          local attempt=0
          while [ "$attempt" -lt "$TRIES" ]
          do
            attempt=$((attempt + 1))
            if nixos-install --no-root-passwd --root /mnt --flake "$URL#$HOST"
            then
              return 0
            fi
            newline
            info "Couldn't finish installation (attempt $attempt/$TRIES)"
          done
          return 1
        }

        if [ "$EUID" -ne 0 ]
        then
          error "This Command must be Executed as 'root'"
        fi
        internet

        # Target Device and Repository
        read -rp "Enter Name of Device to Install: " HOST
        if [ -z "$HOST" ]
        then
          error "Device name cannot be empty"
        fi

        read -rp "Enter Path to Repository (path/URL): " URL
        if [ -z "$URL" ]
        then
          URL=${flake}
        fi

        # Target Disk
        echo "Resolving target disk for '$HOST'..."
        if ! DISK=$(nix eval --raw "$URL#nixosConfigurations.$HOST.config.system.fs.disk")
        then
          error "Couldn't resolve 'system.fs.disk' for '$HOST'"
        fi
        if [ ! -b "$DISK" ]
        then
          error "'$DISK' is not a valid block device" "Set 'system.fs.disk' for '$HOST' to this device's disk"
        fi
        if [ "$(lsblk --nodeps --noheadings --output TYPE "$DISK" | tr -d '[:space:]')" != "disk" ]
        then
          error "'$DISK' is not a whole-disk block device"
        fi

        # Confirm Destructive Wipe
        lsblk --nodeps --output NAME,PATH,SIZE,MODEL,SERIAL "$DISK"
        warn "ALL DATA on '$DISK' will be PERMANENTLY ERASED for Automatic Partitioning"
        read -rp "Type the Disk path to confirm: " CONFIRM
        if [ "$CONFIRM" != "$DISK" ]
        then
          error "Confirmation did not match '$DISK', aborting"
        fi

        # Wipe Stale Signatures
        CLEAN_TARGET=true
        echo "Wiping existing signatures on '$DISK'..."
        swapoff --all 2> /dev/null || true
        zpool labelclear -f "$DISK" 2> /dev/null || true
        for part in "$DISK"*
        do
          if [ -b "$part" ]
          then
            zpool labelclear -f "$part" 2> /dev/null || true
          fi
        done
        wipefs --all --force "$DISK" 2> /dev/null || true
        sgdisk --zap-all "$DISK" 2> /dev/null || true
        newline

        # Partition, Format and Mount Target
        echo "Partitioning and formatting '$DISK'..."
        disko --mode destroy,format,mount --flake "$URL#$HOST"
        newline

        # Install
        echo "Installing System '$HOST' from '$URL' onto '$DISK'..."
        newline
        until install_system
        do
          read -rp "Installation failed after $TRIES attempts. Try again? (Y/*): " choice
          case $choice in
            [Yy]*) newline; info "Retrying installation...";;
            *) cleanup; error "Installation cancelled";;
          esac
        done
        newline

        cleanup
        info "Run 'os setup' after rebooting to finish the install"
        info "Select the (recovery) boot menu option and run the above script as the 'recovery' user"
        restart
      '';
    }
  )
