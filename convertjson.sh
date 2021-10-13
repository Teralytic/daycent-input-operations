#!/bin/bash

# converts existing simulation to json format

# file declaration
jsonFile=daycent.json
pairFile=pairs.delineated

# cleanup before start
rm $jsonFile &> /dev/null
dos2unix *.100

# dump Data100 key-value pairs into file
getPairs() {
    rm $pairFile &> /dev/null
    # remove unkown utf-8 symbols
    for file in *.100; do
        iconv -c -f utf-8 -t ascii "$file" > $file.ununicoded
    done

    # structure data100 object
    for file in *.ununicoded; do
        objectName=$(echo $file | sed -E 's/.100.ununicoded//g' | tr [A-Z] [a-z])
        echo "-$objectName-" >> $pairFile
        while read line; do
            trim=$(echo "$line" | sed -E 's/^ //g' | sed -E 's/\. /.0/g' | sed -E "s/favail/FAVAIL/g"| grep -Po "^[0-9|-].*\s.*?[A-Z].*('|[A-Z]|)")
            key=$(echo $trim | perl -pe 's|^.*?\s||' | sed -E 's/$/ /g' | grep -Po "^.*?\s" | sed -E 's/\ //g' | sed -E "s/'//g" | sed -E 's/\)//g' | sed -E 's/(\(|,)/_/g' | tr [A-Z] [a-z] | sed -E 's/\r\n/\n/g')
            value=$(echo $trim | grep -Po "^.*?\s" | sed -E 's/\s//g')
            if [ "$key" != "" ] || [ "$value" != "" ]
            then
                echo ":$key::$value:" >> $pairFile
            fi
        done < $file
    done
    rm *.ununicoded &> /dev/null
}

jsonInit() {
    echo "{
    \"simulation\": {
        \"data100\": {" >> $jsonFile
}

jsonFmtData100() {
    jsonInit
    comeback=0
    while read line; do
        header=$(echo "$line" | grep -Po "^-.*-" | sed -E 's/-//g')
        value=$(echo "$line" | grep -Po "::.*:" | sed -E 's/://g')
        key=$(echo "$line" | grep -Po ":.*::" | sed -E 's/://g')

        if [ "$header" != "" ] && [ $comeback == 1 ]
        then
            sed -i '$ s/,//' $jsonFile
            echo "                }
            ]," >> $jsonFile
            echo "            \"$header\": [
                {" >> $jsonFile

            echo "working on $header"
            firstKey=1
        elif [ "$header" != "" ]
        then
            echo "            \"$header\": [
                {" >> $jsonFile

            echo "working on $header"
            comeback=1
            firstKey=1
        else
            pair=$(echo "                    \"$key\": $value,")
            if [ $firstKey == 1 ]
            then
                firstKey=0
                searchString="$key"
                echo "$pair" >> $jsonFile
            elif [ "$key" == "$searchString" ]
            then
                sed -i '$ s/,//' $jsonFile
                echo "                },
                {" >> $jsonFile
                echo "$pair" >> $jsonFile
            else
                echo "$pair" >> $jsonFile
            fi
        fi
    done < $pairFile
    sed -i '$ s/,//' $jsonFile
    echo "                }
            ]," >> $jsonFile
}

getPairs
jsonFmtData100
echo "done"