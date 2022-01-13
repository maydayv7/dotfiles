{ lib, pkgs, files, ... }:
with pkgs;
with files;
lib.recursiveUpdate {
  meta.description = "System Setup Script";
  buildInputs = [ coreutils git git-crypt gnupg ];
} (writeShellScriptBin "setup" ''
  #!${runtimeShell}
  set +x

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

  echo "Cloning Repository..."
  git clone https://gitlab.com/maydayv7/dotfiles.git $DIR
  pushd $DIR > /dev/null; git remote add mirror https://github.com/maydayv7/dotfiles; popd > /dev/null
  printf "\n"

  echo "Setting up User..."
  sudo mkdir -p /var/lib/AccountsService/{icons,users}
  echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
  echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
  sudo cp -av $VERBOSE_ARG ${wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
  printf "\n"

  read -p "Enter Path to GPG Keys: " KEY
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
  pushd $DIR > /dev/null; git-crypt unlock; popd > /dev/null
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
