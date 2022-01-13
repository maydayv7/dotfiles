{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "System Setup Script";
  buildInputs = [ coreutils git git-crypt gnupg ];
} (writeShellScriptBin "nixos-setup" ''
  #!${runtimeShell}
  set +x
  ${scripts.commands}

  read -p "Enter Path to GPG Keys (path/.git): " KEY
  LINK='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [ -z "$KEY" ]
  then
    error "Path to GPG Keys cannot be empty"
  elif [[ $KEY =~ $LINK ]]
  then
    echo "Cloning Keys..."
    git clone $KEY keys --progress
    KEY=./keys
  fi
  echo "Importing Keys..."
  for key in $KEY/*.gpg
  do
    gpg --import $key
  done
  rm -rf $KEY
  newline

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

  echo "Cloning Repository..."
  git clone ${path.repo} $DIR
  pushd $DIR > /dev/null
  git-crypt unlock
  git remote add mirror ${path.mirror}
  popd > /dev/null
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
