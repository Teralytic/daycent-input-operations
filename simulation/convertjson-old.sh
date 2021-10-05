#!/bin/bash

# converts .100 files into .json format with <filename> as object declaration every file gets a corresponding .json file
for file in *.100; do
	className=${file//.100/}
	echo "reading $className"
	grep -o \'.*\' $file | tr -d '()' | sed -E "s/'//g" | sed -E "s/,/-/g" | tr '[:upper:]' '[:lower:]' | sed -E 's/^/"/' | sed -E 's/$/": 0,/' | sed -E 's/^/    /' | sed -E "1i$className: {\ " > $className.json;
	echo } >> $className.json
done
