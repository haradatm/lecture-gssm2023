#!/bin/sh

mkdir -p ../tools
cd ../tools
TOOLS=`pwd`

INSTALL_ROOT="${TOOLS}/usr/local"
mkdir -p ${INSTALL_ROOT}
mkdir -p ${TOOLS}/src

export PATH=$PATH:${TOOLS}/usr/local/bin
export CPATH=$CPATH:${TOOLS}/usr/local/include
export LIBRARY_PATH=$LIBRARY_PATH:${TOOLS}/usr/local/lib

if [ -d "${INSTALL_ROOT}/lib/cabocha" ]; then
  echo "Note: cabocha is already installed."
  exit 1
fi

### Install CRF++-

cd ${TOOLS}/src
FILE_ID="0B4y35FiV1wh7QVR6VXJ5dWExSTQ"
gdown --id ${FILE_ID}
tar zxvf CRF++-0.58.tar.gz
cd CRF++-0.58
./configure --prefix=${INSTALL_ROOT}
make
make install

### Install Cabocha

mkdir -p ${TOOLS}/src
cd ${TOOLS}/src
FILE_ID="0B4y35FiV1wh7SDd1Q1dUQkZQaUU"
gdown --id ${FILE_ID}
tar -xvf cabocha-0.69.tar.bz2
cd cabocha-0.69
./configure --prefix=${INSTALL_ROOT} --with-mecab-config=${MECAB_ROOT}/bin/mecab-config --with-charset=utf8 --enable-utf8-only
make
make check
make install
cd python
pip install -e .
cd ${HOME}/.conda/envs/gssm2023/lib
ln -s ${INSTALL_ROOT}/lib/libcabocha.so.5.0.0 ./libcabocha.so.5