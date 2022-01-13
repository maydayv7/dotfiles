{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "System Setup Script";
  buildInputs = [ coreutils git git-crypt gnupg ];
} (writeShellScriptBin "setup" ''
  #!${runtimeShell}
  set +x
  ${commands}

  echo "Preparing Directory..."
  pushd $HOME > /dev/null
  if mount | grep ext4 > /dev/null
  then
    DIR=${path.system}
  else
    DIR=/persist${path.system}
  fi
  sudo rm -rf $DIR
  sudo mkdir $DIR
  sudo chown $USER $DIR
  sudo chmod ugo+rw $DIR
  newline

  read -p "Enter Path to GPG Keys (path/.git): " KEY
  getKeys $KEY
  echo "Importing Keys..."
  for key in $KEY/*.gpg
  do
    gpg --import $key
  done
  rm -rf $KEY
  newline

  echo "Cloning Repository..."
  git clone ${path.repo} $DIR
  pushd $DIR > /dev/null
  git-crypt unlock
  git remote add mirror ${path.mirror}
  popd > /dev/null
  newline

  echo "Setting up User..."
  sudo mkdir -p /var/lib/AccountsService/{icons,users}
  echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
  echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
  sudo cp -av $VERBOSE_ARG ${wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
  newline

  echo "Applying Configuration..."
  if [ "$DIR" == "/persist${path.system}" ]
  then
    sudo umount -l ${path.system}
    sudo mount $DIR
  fi
  sudo nixos-rebuild switch --flake ${path.system}
  popd > /dev/null
'')
