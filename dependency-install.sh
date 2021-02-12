#!/bin/bash

DIR=`dirname $0`
DIR="$(cd $DIR; pwd)"

ARCH=`uname -m`

case $ARCH in
	armv5tl|armv6l|armv7l|aarch64)
		TARGET=arm
		;;
	i686|i386)
		TARGET=386
		;;
	x86_64)
		TARGET=amd64
		;;
	*)
		echo "Unsupported arch"
		exit 1
		;;
esac

if [ `id -u $USER` = "0" ]; then
    echo "Please run the script as a regular user with sudo privilege."
    exit 1
fi

cd /tmp
wget -c "https://releases.hashicorp.com/terraform/0.14.6/terraform_0.14.6_linux_$TARGET.zip"
unzip "terraform_0.14.6_linux_$TARGET.zip"
mkdir -p ~/bin
mv terraform ~/bin/
pip3 install --user awscli
echo -e "\nexport PATH=\"\$PATH:~/.local/bin:~/bin\"\n" >> ~/.profile
