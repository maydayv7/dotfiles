{ lib, pkgs, path, files, ... }:
with pkgs;
lib.recursiveUpdate
{ meta.description = "System Setup Script"; }
(writeShellScriptBin "setup"
''
  #!${runtimeShell}
  set +x

  if mount | grep ext4 > /dev/null
  then
    DIR=${path.system}
  else
    DIR=/persist${path.system}
  fi

  echo "Preparing Directory..."
  sudo rm -rf $DIR
  sudo mkdir $DIR
  sudo chown $USER $DIR
  sudo chmod ugo+rw $DIR
  printf "\n"

  echo "Cloning Repo..."
  git clone https://github.com/maydayv7/dotfiles.git $DIR
  printf "\n"

  echo "Setting up User..."
  sudo mkdir -p /var/lib/AccountsService/{icons,users}
  echo "[User]" | sudo tee /var/lib/AccountsService/users/$USER &> /dev/null
  echo "Icon=/var/lib/AccountsService/icons/$USER" | sudo tee -a /var/lib/AccountsService/users/$USER &> /dev/null
  sudo cp -av $VERBOSE_ARG ${files.wallpapers}/Profile.png /var/lib/AccountsService/icons/$USER
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
  pushd $DIR > /dev/null; git-crypt unlock; popd > /dev/null
  printf "\n"

  if [ "$DIR" == "/persist${path.system}" ]
  then
    sudo umount -l ${path.system}
    sudo mount $DIR
  fi

  sudo nixos-rebuild switch --flake ${path.system}
'')
