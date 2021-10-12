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

jsonFmt() {
    jsonInit
    keyList=""
    while read line; do
        header=$(echo "$line" | grep -Po "^-.*-" | sed -E 's/-//g')
        value=$(echo "$line" | grep -Po "::.*:" | sed -E 's/://g')
        key=$(echo "$line" | grep -Po ":.*::" | sed -E 's/://g')

        if [ "$header" != "" ]
        then
            echo "                \"$header\": [
                    {" >> $jsonFile
            keyList=""

            echo "cleared $header"
        else
            lineWithComma=$(echo "                        \"$key\": $value,")
            lineWithoutComma=$(echo "                        \"$key\": $value")
            searchString=$(echo "$keyList" | grep -Po "${key}")
            isFirstObj="yes"
            if [ "$key" != "$searchString" ]
            then
                keyList=$(echo "$keyList:$key")
                echo "$lineWithComma" >> $jsonFile
            elif [ "$isFirstObj" == "yes" ]
            then
                echo "                        \"$key\": $value," >> $jsonFile
                isFirstObj=""
            else
                echo "$lineWithoutComma yes" >> $jsonFile
                echo "}," >> $jsonFile
                keyList="$key"
                isFirstObj="yes"
                # make new object
                # clear keyList
            fi
            # add final closing brace
        fi
        
    done < $pairFile
}



# # format pair into json
# jsonFmt() {
#     key="$1"
#     value="$2"

#     while read line; do
        
#     done < $jsonFile

#     # test string lol
#     echo "                                "\"$key\"": $value," >> $jsonFile
# }

jsonFmt

# cleanup env
echo "done"