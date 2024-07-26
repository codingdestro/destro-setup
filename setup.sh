#!/bin/bash

#check if the scripts is run with root privilegs
if [ "$(id -u)" -ne 0 ];then
  echo "This scripts must be run as root"
  exit 1
fi

distro_type="debian"

#check the distro is Debian or Arch
if [ -f /etc/debian_version ];then
  echo "Debian"
  distro_type="debian"

elif [ -f /etc/arch-release ];then
  echo "Arch"
  distro_type="arch"
else
  echo "Unkown"
fi

#updating and upgrading the distro up-to-date 
if [ "$distro_type" == "debian"];then
  sudo apt-get update && sudo apt-get upgrade -y
fi


#installing tools for setup
if [ "$distro_type" == "debian"];then
  sudo apt-get install curl git wget kitty net-tools software-properties-common
fi


#install the text editors
if [ "$distro_type" == "debian"];then
  echo "installing the zed editor"
  curl -f https://zed.dev/install.sh | sh

  echo "installing the vscode"
  wget "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1e16e1e6214d7c44d078b1f0607b2388f29d729/code_1.91.1-1720564633_amd64.deb" -O vscode.deb
  
  sudo dpkg -i vscode.deb
fi

# install the latest neovim

wget "https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz" -O nvim.tar.gz

if [$? -ne 0 ]; then
  echo "failed to download neovim"
  exit 1
else
  tar -xf nvim.tar.gz
  cd nvim-*
  sudo cp -r bin/nvim /usr/bin/.
  sudo cp -r lib/* /usr/lib/.
  sudo cp -r share/* /usr/share/.
  nvim --version
  if [ $? -ne 0 ]; then
    echo "failed to install neovim"
    exit 1
  fi
fi

#install the latest node.js and npm

wget "https://nodejs.org/dist/v20.16.0/node-v20.16.0-linux-x64.tar.xz" -O node.tar.xz
if [$? -ne 0 ]; then
  echo "failed to download node.js"
  exit 1
else
  tar -xf node.tar.xz 
  cd node-*
  sudo cp -r bin/* /usr/bin/.
  sudo cp -r include/* /usr/include/.
  sudo cp -r lib/* /usr/lib/.
  sudo cp -r share/* /usr/share/.

  node -v && npm -v && npx -v
  if [ $? -ne 0 ]; then
    echo "failed to install node.js"
    exit 1
  fi

fi


#install rust language
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "failed to install rust lang"
  exit 1
fi



