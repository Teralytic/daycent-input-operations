#/bin/bash

rm wth.go >> /dev/null

        echo "

type Weather struct {
    Usexdrvrs C.int \`json:\"usexdrvrs\"\`
    WeatherData []WeatherData \`json:\"weatherData\"\`
}" >> wth.go

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/driver//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*?:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | sed -E 's/.*/\u&/')

    if [ "$header" != "" ]
    then
        echo "
type $header struct {" >> wth.go
    elif [ "$trim" != "" ]
    then
        echo "  $uppercaseTrim C.int \`json:\"$trim\"\`" >> wth.go
    fi

done < wth.delineated

sed -i '1d' wth.go

echo "}" >> wth.go

echo "done with .wth file"