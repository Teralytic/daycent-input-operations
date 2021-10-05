#!/bin/bash

rm *.yml

# put into yml format
yml() {
    line=$1
    desc=$(echo "$2" | sed -E 's/[ \t]*$//' | sed -E 's/^[ \t]*//' | sed -E 's/^, //g' | sed -E '/^$/d' | sed -E 's/"//g')
    name=$3
    for i in {1..5}; do
	    desc=$(echo "$desc" | sed -E 's/\ \ / /g')
    done

    echo "        $line:
            description: \"$desc\"
            type: integer" >> $name.yml
}


# get all parameters in their respective .yml files
for file in *.def; do
    echo "formatting $file";
    fileName=${file//.def/}.txt
    grep -Po ^.*?\  $file | sed -E 's/ //' | sed -E 's/\*\*\*//' | sed -E '/[A-Z]/d' | sed -E '/^$/d' | sed -E 's/\)//' | sed -E 's/\(/-/' >> $fileName
done

# get the definitions of each parameter
for file in *.txt; do
    echo "getting description for $file"
    fileName=${file//.txt/}
    # make yml schema object
    echo "$fileName:
    description:
    type: object
    properties:" >> $fileName.yml
    fileOneLineUnformatted=$(cat $fileName.def | tr -d '\r\n')
    fileOneLine=${fileOneLineUnformatted//(/-}
    while read line; do
        # now format the description
        unformatDesc=$(grep -Po $line.*?Range: <<< $fileOneLine)
        formatDesc1=${unformatDesc//$line/}
        formatDesc2=${formatDesc1//Range:/}
        description=${formatDesc2//\)/}

        yml "$line" "$description" "$fileName"
    done <$file
done

rm *.txt

cat *.yml > daycent.yml
