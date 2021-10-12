#!/bin/bash

rm schema.go

echo "
package godaycent

import \"C\"

type Schema struct {
    Simulation Simulation \`json:\"simulation\"\`
}

type Simulation struct {
    Data100 Data100 \`json:\"data100\"\`
    Soils []Soils \`json:\"soils\"\`
    Weather Weather \`json:\"weather\"\`
}" >> schema.go

echo "starting Data100"

rm data100.go
rm data100

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | sed -E 's/.*/\u&/')
    # create struct
    if [ "$header" != "" ]
    then
        echo "}

type $header struct {" >> data100.go
        echo "$header" >> data100

    elif [ "$trim" != "" ]
    then
        echo "$uppercaseTrim C.int \`json:\"$trim\"\`" >> data100.go
    fi
done < data100.delineated

# post processing
sed -i '1d' data100.go
echo "}" >> data100.go
    echo "
type Data100 struct {" >> data100-head.go

while read line; do
    lowercaseLine=$(echo "$line" | tr [A-Z] [a-z])
    echo "  $line []$line \`json:\"$lowercaseLine\"\`" >> data100-head.go
done < data100
echo "}" >> data100-head.go

cat data100-head.go data100.go >> schema.go

rm data100
rm data100-head.go
rm data100.go

echo "done with Data100"

# build soils struct

echo "starting Soils"

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | tr [a-z] [A-Z])
    
    if [ "$header" != "" ]
    then
        echo "
type $header struct {" >> schema.go

    elif [ "$trim" != "" ]
    then
        echo "$uppercaseTrim C.int \`json:\"$trim\"\`" >> schema.go
    fi
done < soils.delineated

echo "}" >> schema.go
echo "done with Soils"

echo "starting Weather"

        echo "
type Weather struct {
    Usexdrvrs C.int \`json:\"usexdrvrs\"\`
    WeatherData []WeatherData \`json:\"weatherData\"\`
}" >> schema.go

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/driver//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*?:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | sed -E 's/.*/\u&/')

    if [ "$header" != "" ]
    then
        echo "
type $header struct {" >> schema.go
    elif [ "$trim" != "" ]
    then
        echo "  $uppercaseTrim C.int \`json:\"$trim\"\`" >> schema.go
    fi

done < wth.delineated

sed -i '1d' schema.go

echo "}" >> schema.go

echo "done with Weather"