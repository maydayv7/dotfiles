# Useful Commands

error() {
  echo -e "\n\033[0;31merror:\033[0m $1"
  if [ -n "$2" ]
  then
    echo -e "\n$2"
  fi
  exit 7
}

extract () {
  if [ -f "$1" ]
  then
    case $1 in
    *.tar.bz2) tar xvjf "$1";;
    *.tar.gz) tar xvzf "$1";;
    *.tar.xz) tar Jxvf "$1";;
    *.bz2) bunzip2 "$1";;
    *.rar) rar x "$1";;
    *.gz) gunzip "$1";;
    *.tar) tar xvf "$1";;
    *.tbz2) tar xvjf "$1";;
    *.tgz) tar xvzf "$1";;
    *.zip) unzip -d "${1//\.zip/}" "$1";;
    *.Z) uncompress "$1";;
    *.7z) 7z x "$1";;
    *) error "Can't Extract '$1'" ;;
    esac
  else
    error "File '$1' is invalid"
  fi
}

internet() {
  if ! [ "$(echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1)" -eq 0 ]
  then
    error "You are Offline, Please Connect to the Internet"
  fi
}

keys() {
  read -rp "Enter Path to GPG Keys (path/.git): " KEY
  pushd "$HOME" > /dev/null || exit
  LINK='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [ -z "$KEY" ]
  then
    error "Path to GPG Keys cannot be empty"
  elif [[ $KEY =~ $LINK ]]
  then
    echo "Cloning Keys..."
    git clone "$KEY" keys --progress
  else
    cp -r "$KEY"/. ./keys
  fi
  echo "Importing Keys..."
  find ./keys -name '*.gpg' -exec gpg --import {} \+
  rm -rf ./keys
  popd > /dev/null || exit
}

newline() {
  echo -e "\n";
}

restart() {
  read -rp "Do you want to Reboot the System? (Y/N): " choice
    case $choice in
      [Yy]*) reboot;;
      *) exit;;
    esac
}

up () {
  LIMIT=$1
  P=$PWD/..
  for ((i=1; i < LIMIT; i++))
  do
    P=$P/..
  done
  cd "$P" || exit
}

warn() {
  echo -e "\n\033[0;35mwarning:\033[0m $1"
  if [ -n "$2" ]
  then
    echo -e "\n$2"
  fi
}
