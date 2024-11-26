#!/bin/bash

echo "**** bicep lint start ****"

directory=$1
err_cnt=0
while IFS= read -r file; do
  echo "checking... $file"
  res=$(az bicep lint --file "$file" 2>&1)
  if [ $? -ne 0 ] || echo "$res" | grep -q "BCP"; then
    err_cnt=$((err_cnt + 1))
    echo "$res"
  fi
done < <(find . -wholename "./${directory}/*.bicep" -o -wholename "./${directory}/*.bicepparam")

if [ $err_cnt -ge 1 ]; then
  exit 1
fi

echo "**** bicep lint finish ****"

exit 0
