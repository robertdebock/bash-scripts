#!/bin/bash

for file in "$@" ; do
 exiftool -AllDates="$(exiftool "${file}" | grep 'Create Date' | awk '{print  $(NF-1), $NF }')" -overwrite_original "${file}" 
done
