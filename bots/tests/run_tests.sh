#!/bin/bash

set -e

FILES=$(ls *.lua)

for FILE in $FILES
do
  echo "Run $FILE:"
  lua $FILE $1
done