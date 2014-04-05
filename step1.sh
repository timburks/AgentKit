#!/bin/bash
#
# Use this script in a bare Ubuntu distribution to install 
# clang, libobjc2, GNUstep, and other dependencies that
# will allow you to build and run Nu.
#
# libobjc2 is an updated runtime that seeks compatibility 
# with Apple's modern Objective-C runtime. This new runtime
# allows Nu to be ported to Linux+GNUstep without difficulty.
#
# Tested with ubuntu-12.04.2-server-amd64.iso. 
# Other Ubuntu and Debian installations may also work well.
#

sudo apt-get update
sudo apt-get install curl -y
sudo apt-get install ssh -y
sudo apt-get install git -y
sudo apt-get install libreadline-dev -y
sudo apt-get install libicu-dev -y
sudo apt-get install openssl -y
sudo apt-get install build-essential -y
sudo apt-get install clang -y
sudo apt-get install libblocksruntime-dev -y
sudo apt-get install libkqueue-dev -y
sudo apt-get install libpthread-workqueue-dev -y
sudo apt-get install gobjc -y
sudo apt-get install libxml2-dev -y
sudo apt-get install libjpeg-dev -y
sudo apt-get install libtiff-dev -y
sudo apt-get install libpng12-dev -y
sudo apt-get install libgnutls-dev -y

sudo apt-get remove libdispatch-dev -y
sudo apt-get install gdb -y

#
# A few modifications were needed to fix problems with 
# libobjc2 and gnustep-base. To maintain stability, we
# work with a fork on github.
#
git clone https://github.com/timburks/gnustep-libobjc2.git
git clone https://github.com/timburks/gnustep-make.git
git clone https://github.com/timburks/gnustep-base.git

echo Installing libobjc2
export CC=clang

cd gnustep-libobjc2
make clean
make
sudo make install
cd ..

cd gnustep-make
./configure
make clean
make
sudo make install
cd ..

cd gnustep-base
./configure
make clean
make
sudo make install
cd ..

sudo apt-get install libdispatch-dev -y

git clone https://github.com/timburks/nu.git

cd nu
git checkout master
make
./mininush tools/nuke install
cd ..


sudo apt-get install libdispatch-dev -y

git clone https://github.com/timburks/nu.git

cd nu
git checkout master
make
./mininush tools/nuke install
cd ..

sudo apt-get install libevent-dev -y
sudo apt-get install uuid-dev -y
sudo apt-get install libssl-dev -y
sudo apt-get install cmake -y

git clone https://github.com/timburks/libevhtp
cd libevhtp/build
cmake ..
make
make install
cd ../..

git clone https://github.com/timburks/AgentKit.git

cd AgentKit/frameworks/AgentHTTP
nuke install
cd ../AgentJSON
nuke install
cd ../AgentXML
nuke install
cd ../AgentCrypto
nuke install
cd ../AgentMongoDB
nuke install
cd ../..



