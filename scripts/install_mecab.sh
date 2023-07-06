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

if [ -d "${INSTALL_ROOT}/lib/mecab" ]; then
  echo "Note: mecab is already installed."
  exit 1
fi

### Install MeCab

cd ${TOOLS}/src
git clone https://github.com/taku910/mecab
cd mecab/mecab
./configure --with-charset=utf8 --prefix=${INSTALL_ROOT}
make >> $${LOG_FILE} 2>&1
make install

cd ${TOOLS}/src/mecab/mecab-ipadic
./configure --with-charset=utf8 --prefix=${INSTALL_ROOT} --with-mecab-config=${INSTALL_ROOT}/bin/mecab-config
make
make install

echo '"湯畑",-1,-1,1,名詞,一般,*,*,*,*,湯畑,ユバタケ,ユバタケ,USER"' > ${INSTALL_ROOT}/lib/mecab/dic/ipadic/user_dic.csv
echo "userdic = ${INSTALL_ROOT}/lib/mecab/dic/ipadic/user.dic" >> ${INSTALL_ROOT}/etc/mecabrc
${INSTALL_ROOT}/libexec/mecab/mecab-dict-index -d ${INSTALL_ROOT}/lib/mecab/dic/ipadic -u ${INSTALL_ROOT}/lib/mecab/dic/ipadic/user.dic -f utf-8 -t utf-8 ${INSTALL_ROOT}/lib/mecab/dic/ipadic/user_dic.csv

cd ${TOOLS}/src/mecab/mecab/python
sed -i".org" -e "s/return string.split (cmd1(str))/return cmd1(str).split()/g" setup.py
python setup.py build
pip install -e .
cd ${HOME}/.conda/envs/gssm2023/lib
ln -s ${INSTALL_ROOT}/lib/libmecab.so.2.0.0 ./libmecab.so.2
