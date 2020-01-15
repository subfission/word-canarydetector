#!/bin/sh
# Word Document Canary Token Detector
# This script will detect canary token in word documents

file=$1

if [ ! -f $file ]; then
  echo
  echo "Canary Token Detector for Microsoft Word Documents"
  echo
  read -p "Please enter a Word document file name: " file
fi

if [ ! -f $file ]; then
  echo "File not exists"
  exit 1
fi

if [[ $file == *.docx ]] || [[ $file == *.doc ]]; then
  unzip -o $file
  if [ ! -f word/footer1.xml ]; then
    echo "This file appears normal"
    exit 1
  fi
  
  if grep -q canarytoken word/footer2.xml word/footer1.xml word/footer3.xml word/header1.xml word/header2.xml word/header3.xml; then
    tput setaf 1
    tput bel
    echo "[x] Canary token detected!"
    tput sgr0
  else
    echo "This file appears normal"
  fi
  rm -rf word docProps _rels
else
  echo "This is not a valid word document file" > 2
  exit 1
fi
