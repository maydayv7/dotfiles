# Useful Commands

error() {
  echo -e "\n\033[0;31merror:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
  exit 7
}

newline() {
  echo -e "\n";
}

warn() {
  echo -e "\n\033[0;35mwarning:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
}
