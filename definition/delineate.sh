#!/bin/bash

rm delineated
rm *.txt

txt() {
    line=$1
    desc=$(echo "$2" | sed -E 's/[ \t]*$//' | sed -E 's/^[ \t]*//' | sed -E 's/^, //g' | sed -E '/^$/d' | sed -E 's/"//g' | sed -E 's/://g' | sed -E 's/-//g' | sed -E 's/;//g')
    name=$3
    for i in {1..5}; do
	    desc=$(echo "$desc" | sed -E 's/\ \ / /g')
    done

    format=$(echo "$line" | sed -E 's/,/_/g' | sed -E 's/-/_/g')

    echo ":$format::$desc:" >> $name-description.txt
}

for file in *.def; do
    echo "formatting $file";
    fileName=${file//.def/}.txt
    grep -Po ^.*?\  $file | sed -E 's/ //' | sed -E 's/\*\*\*//' | sed -E '/[A-Z]/d' | sed -E '/^$/d' | sed -E 's/\)//' | sed -E 's/\(/-/' >> $fileName
done

for file in *.txt; do
    echo "getting description for $file"
    fileName=${file//.txt/}
    fileOneLineUnformatted=$(cat $fileName.def | tr -d '\r\n')
    fileOneLine=${fileOneLineUnformatted//(/-}
    while read line; do
        # now format the description
        unformatDesc=$(grep -Po $line.*?Range: <<< $fileOneLine)
        formatDesc1=${unformatDesc//$line/}
        formatDesc2=${formatDesc1//Range:/}
        description=${formatDesc2//\)/}

        txt "$line" "$description" "$fileName"
    done <$file
done

# cat into file
for file in *-description.txt; do
    echo "catting $file"
    fileName=${file//-description.txt/}
    echo "-$fileName-" >> delineated
    cat $file >> delineated
done

rm *.txt