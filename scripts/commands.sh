# Useful Commands

error() {
  echo -e "\n\033[0;31merror:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
  exit 7
}

extract () {
  if [ -f $1 ]
  then
    case $1 in
    *.tar.bz2)   tar xvjf $1    ;;
    *.tar.gz)    tar xvzf $1    ;;
    *.tar.xz)    tar Jxvf $1    ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       rar x $1       ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xvf $1     ;;
    *.tbz2)      tar xvjf $1    ;;
    *.tgz)       tar xvzf $1    ;;
    *.zip)       unzip -d `echo $1 | sed 's/\(.*\)\.zip/\1/'` $1;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1        ;;
    *)           echo "Can't Extract '$1'" ;;
    esac
  else
    error "File '$1' is invalid"
  fi
}

newline() {
  echo -e "\n";
}

up () {
  LIMIT=$1
  P=$PWD/..
  for ((i=1; i < LIMIT; i++))
  do
    P=$P/..
  done
  cd $P
}

warn() {
  echo -e "\n\033[0;35mwarning:\033[0m $1"
  if ! [ -z "$2" ]
  then
    echo -e "\n$2"
  fi
}
