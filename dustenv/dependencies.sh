# Try to detect the package manager
check_command() {
  # check if command $1 exists in PATH
  command_type=$(type "$1" 2>/dev/null)
  if echo "$command_type" | grep -q "not found"
  then
    return 1
  elif echo "$command_type" | grep -q "alias"
  then
    return 1
  else
    return 0
  fi
}

ask_yn() {
  # ask user if coninue or not prompting for detected distro ($1) and package manager ($2)

  echo -n "It seems that you're using a $1-based distro. Dow you want to continue installing Python build dependencies using $2 package manager? [y/n] " >&2
  read -r option
  if test $option = "y" || test $option = "Y"
  then
    return 0
  else
    return 1
  fi
}

install_depencies() {
  # check package manager and installs dependencies
  if check_command "apt" || check_command "apt-get"
  then
    if ask_yn "Debian- or Ubuntu" "apt-get"
    then 
      sudo apt-get update; sudo apt-get install make build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
      return $?
    fi

  elif check_command "brew"
  then
    if ask_yn "MacOS" "brew"
    then 
      brew install openssl readline sqlite3 xz zlib tcl-tk
      return $?
    fi

  elif check_command "yum"
  then
    if ask_yn "Fedora (<21) or CentOS" "yum"
    then 
      yum install gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
      return $?
    fi

  elif check_command "dnf"
  then
    if ask_yn "Fedora (>=22)" "dnf"
    then 
      dnf install make gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel
      return $?
    fi

  elif check_command "zypper"
  then
    if ask_yn "OpenSUSE" "zypper"
    then 
      zypper install gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
  readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel make
      return $?
    fi

  elif check_command "pacman"
  then
    if ask_yn "Arch" "pacman"
    then
      pacman -S --needed base-devel openssl zlib xz tk
      return $?
    fi

  elif check_command "zypper"
  then
    if ask_yn "OpenSUSE" "zypper"
    then 
      zypper install gcc automake bzip2 libbz2-devel xz xz-devel openssl-devel ncurses-devel \
  readline-devel zlib-devel tk-devel libffi-devel sqlite3-devel make
      return $?
    fi

  elif check_command "eopkg"
  then
    if ask_yn "Solus" "eopkg"
    then 
      sudo eopkg it -c system.devel
      sudo eopkg install git gcc make zlib-devel bzip2-devel readline-devel sqlite3-devel openssl-devel tk-devel
      return $?
    fi

  elif check_command "apk"
  then
    if ask_yn "Alpine" "apk"
    then 
      apk add --no-cache git bash build-base libffi-dev openssl-dev bzip2-dev zlib-dev xz-dev readline-dev sqlite-dev tk-dev
      return $?
      if echo $version | grep -q "3.7"
      then
        apk add linux-headers 
        return $?
      fi
    fi

  elif check_command "xbps-install"
  then
    if ask_yn "Void-Linux" "xbps-install"
    then 
      xbps-install base-devel bzip2-devel openssl openssl-devel readline readline-devel sqlite-devel xz zlib zlib-devel
      return $?
    fi

  else
    echo "Sorry, we cannot detect your package manager. Please, install the Python build dependencies by yourself. For more info visit https://github.com/pyenv/pyenv/wiki"
    return 1

  fi

}
