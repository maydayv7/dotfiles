{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "System Setup Script";
  buildInputs = [ coreutils git git-crypt gnupg ];
} (writeShellScriptBin "setup" ''
  #!${runtimeShell}
  set +x
  ${scripts.commands}

  echo "Preparing Directory..."
  pushd $HOME > /dev/null
  if mount | grep ext4 > /dev/null
  then
    DIR=${path}
  else
    DIR=/persist${path}
  fi
  sudo rm -rf $DIR
  sudo mkdir $DIR
  sudo chown $USER $DIR
  sudo chmod ugo+rw $DIR
  printf "\n"

  read -p "Enter Path to GPG Keys: " KEY
  getKeys $KEY
  echo "Importing Keys..."
  for key in $KEY/*.gpg
  do
    gpg --import $key
  done
  rm -rf $KEY
  printf "\n"

  echo "Cloning Repository..."
  git clone ${repo} $DIR
  pushd $DIR > /dev/null
  git-crypt unlock
  git remote add mirror ${mirror}
  popd > /dev/null
  printf "\n"

  echo "Setting up User..."
  sudo mkdir -p /var/lib/AccountsService/{icons,users}
  echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
  echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
  sudo cp -av $VERBOSE_ARG ${wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
  printf "\n"

  echo "Applying Configuration..."
  if [ "$DIR" == "/persist${path}" ]
  then
    sudo umount -l ${path}
    sudo mount $DIR
  fi
  sudo nixos-rebuild switch --flake ${path}
  popd > /dev/null
'')
