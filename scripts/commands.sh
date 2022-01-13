error() {
  echo -e "\n\033[0;31merror:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
  exit 7
}

getKeys() {
  LINK='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [ -z "$1" ]
  then
    error "Path to GPG Keys cannot be empty"
  elif [[ $1 =~ $LINK ]]
  then
    echo "Cloning Keys..."
    git clone $1 keys --progress
    $1=./keys
  fi
}

newline() { echo -e "\n"; }

warn() {
  echo -e "\n\033[0;35mwarning:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
}
