#!/bin/bash

# converts from *.delineate to yaml structure for insertion to swagger.yaml

swagger=swaggerschema.yaml

rm $swagger &> /dev/null

echo "DaycentInputs:
    type: object
    properties:
        simualtion:
            type: object
            properties:
                data100:
                    type: object
                    properties:" >> $swagger

# convert data100
while read line; do
    header=$(echo $line | grep -Po ^-.*- | sed -E 's/-//g')
    trim=$(echo $line | grep -Po ^:.*:: | sed -E 's/://g')
    desc=$(echo $line | grep -Po ::.*: | sed -E 's/://g')

    if [ "$header" != "" ]
    then
        echo "                        $header:
                            type: object
                            properties:" >> $swagger
    elif [ "$trim" != "" ]
    then
        echo "                                $trim:
                                    description: \"$desc\"
                                    type: integer" >> $swagger
    fi 
done < data100.delineated

# convert soils
echo "                soils:
                    type: array
                    items:
                        type: object
                        properties:" >> $swagger
while read line; do
    trim=$(echo $line | grep -Po ^:.*:: | sed -E 's/://g')
    desc=$(echo $line | grep -Po ::.*: | sed -E 's/://g')
    if [ "$trim" != "" ]
    then
        echo "                                $trim:
                                    description: \"$desc\"
                                    type: integer" >> $swagger
    fi 
done < soils.delineated

# convert weather
echo "                weather:
                    type: object
                    properties:
                        usexdrvrs:
                            description: \"use extra weather drivers to designate the format of the weather data\"
                            type: integer
                        weatherData:
                            type: array
                            items:
                                type: object
                                properties:" >> $swagger
while read line; do
    trim=$(echo $line | grep -Po ^:.*?:: | sed -E 's/://g')
    desc=$(echo $line | grep -Po ::.*?::: | sed -E 's/://g')
    if [ "$trim" != "" ]
    then
        echo "                                    $trim:
                                        description: \"$desc\"
                                        type: integer" >> $swagger
    fi 
done < wth.delineated

# indent the file
sed -i 's/^/    /' $swagger

echo "done"