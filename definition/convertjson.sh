#!/bin/bash

# converts existing simulation to json format

jsonFile=daycent.json

rm $jsonFile &> /dev/null
dos2unix *.100

echo "{
    \"simulation\": {
        \"data100\": {" >> $jsonFile

# format pair into json
jsonFmt() {
    key="$1"
    value="$2"

    # test string lol
    echo "                                "\"$key\"": $value," >> $jsonFile
}

# get key-value pairs from .100 files
getPair() {
    line=$(echo "$1")
    trim=$(echo "$line" | sed -E 's/^ //g' | sed -E 's/\. /.0/g' | sed -E "s/favail/FAVAIL/g"| grep -Po "^[0-9|-].*\s.*?[A-Z].*('|[A-Z]|)")
    key=$(echo $trim | perl -pe 's|^.*?\s||' | sed -E 's/$/ /g' | grep -Po "^.*?\s" | sed -E 's/\ //g' | sed -E "s/'//g" | sed -E 's/\)//g' | sed -E 's/(\(|,)/_/g' | tr [A-Z] [a-z] | sed -E 's/\r\n/\n/g')
    value=$(echo $trim | grep -Po "^.*?\s" | sed -E 's/\s//g')
    if [ "$key" != "" ] || [ "$value" != "" ]
    then
        jsonFmt "$key" "$value"
    fi
}

# remove unkown utf-8 symbols
for file in *.100; do
    iconv -c -f utf-8 -t ascii "$file" > $file.ununicoded
done

# structure data100 object
for file in *.ununicoded; do
    objectName=$(echo $file | sed -E 's/.100.ununicoded//g' | tr [A-Z] [a-z])
    # todo, improve this check, checks site name and asks which one to use
    if [ $objectName == "centralsjv" ]
    then
        objectName="site"
    fi
    echo "                    \"$objectName\": [
                        {" >> $jsonFile
    while read line; do
        getPair "$line"
    done < $file
    echo "                        }
                    ]" >> $jsonFile

done


rm *.ununicoded &> /dev/null