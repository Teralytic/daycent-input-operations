# Scripts for manipulating simulations and definitions of data used by the Daycent Model

* convertsim.sh - converts from json to simulation [todo]
* convertjson.sh - converts from simulation to json [in progress]
* delineate.sh - converts .def files into delineateable form [done]
* gostruct.sh - converts from delineateable form to go struct [todo]
* ymlconvert.sh - converts from delineateable form to yaml [in progress]
* cstruct.sh - converts from delineateable form to c struct [todo]
* fortstruct.sh - converts from delineateable form to fortran struct [todo]

## Daycent inputs, how they work

* you have .100 files with all the required data to be entered found in the swagger.yaml, some are absolutely required but most can be left in default values
* sitepar.in has additional values that are not required but add extra functionality to the model
* make a \<site\>.wth file

    ``` txt
    set one of these driver modes for the desired weather accuracy in sitepar.in under usexdrvrs

    Use extra weather drivers = 0 
    
    Column  1 - Day of month, 1-31 
    Column  2 - Month of year, 1-12 
    Column  3 - Year (4 digits) 
    Column  4 - Day of the year, 1-366 
    Column  5 - Maximum temperature for day, ºC 
    Column  6 - Minimum temperature for day, ºC 
    Column  7 - Precipitation for day, cm 
    
    Use extra weather drivers = 1 
    
    Column  1 - Day of month, 1-31 
    Column  2 - Month of year, 1-12 
    Column  3 - Year (4 digits) 
    Column  4 - Day of the year, 1-366 
    Column  5 - Maximum temperature for day, ºC 
    Column  6 - Minimum temperature for day, ºC 
    Column  7 - Precipitation for day, cm 
    Column  8 - Solar radiation, langleys day-1 
    Column  9 - Relative humidity, %, 1-100 
    Column 10 - Wind speed, miles per hour 
    
    Use extra weather drivers = 2 
    
    Column  1 - Day of month, 1-31 
    Column  2 - Month of year, 1-12 
    Column  3 - Year (4 digits) 
    Column  4 - Day of the year, 1-366 
    Column  5 - Maximum temperature for day, ºC 
    Column  6 - Minimum temperature for day, ºC 
    Column  7 - Precipitation for day, cm 
    Column  8 - Mean daytime solar radiation flux, W m-2 
    Column  9 - vapor pressure deficit, kPa

    Use extra weather drivers = 3 (DayCent_Photosyn_UV only) 
    
    Column  1 - Day of month, 1-31 
    Column  2 - Month of year, 1-12 
    Column  3 - Year (4 digits) 
    Column  4 - Day of the year, 1-366 
    Column  5 - Maximum temperature for day, ºC 
    Column  6 - Minimum temperature for day, ºC 
    Column  7 - Precipitation for day, cm 
    Column  8 - Solar radiation, langleys day-1 
    Column  9 - Relative humidity, %, 1-100 
    Column 10 - Wind speed, miles per hour 
    Column 11 - Mean daytime solar radiation flux, W m-2 
    Column 12 - vapor pressure deficit, kPa day-1 
    
    Use extra weather drivers = 4 (DDcentEVI only) 
    
    Column  1 - Day of month, 1-31 
    Column  2 - Month of year, 1-12 
    Column  3 - Year (4 digits) 
    Column  4 - Day of the year, 1-366 
    Column  5 - Maximum temperature for day, ºC 
    Column  6 - Minimum temperature for day, ºC 
    Column  7 - Precipitation for day, cm 
    Column  8 - Solar radiation, mean W m-2 day-1 
    Column  9 - EVI (Enhanced Vegetation Index derived from MODIS)
    ```

  * build soils.in with the ADEP parameters in fix.100
  
  ``` txt
  Column  1 – Upper depth of soil layer (cm) 
  Column  2 – Lower depth of soil layer (cm) 
  Column  3 – Bulk density of soil layer (g cm-3) 
  Column  4 – Field capacity of soil layer, volumetric fraction 
  Column  5 – Wilting point of soil layer, volumetric fraction 
  Column  6 – Evaporation coefficient for soil layer (currently not being used) 
  Column  7 – Fraction of roots in soil layer, these values must sum to 1.0 but if they don’t the model will normalize the values to 1.0 
  Column  8 – Fraction of sand in soil layer, 0.0 - 1.0 
  Column  9 – Fraction of clay in soil layer, 0.0 - 1.0 
  Column 10 – Organic matter in soil layer, fraction 0.0 - 1.0 
  Column 11 – The amount that volumetric soil water content can drop below wilting point for soil layer (deltamin, volumetric fraction).  The 
  minimum soil water content of a layer = wilting point – deltamin. 
  Column 12 – Saturated hydraulic conductivity of soil layer (ksat, cm sec-1) 
  Column 13 – pH of soil layer

  NOTES: 
  Fraction of silt for soil layer is computed as follows: 
  silt = 1.0 - (sand + clay) 
 
  For the trace gas subroutines it is currently recommended to use the following layering structure for the top 3 soil layers in your soils.in file: 
 
  layer 1 - 0.0 cm to  2.0 cm 
  layer 2 - 2.0 cm to  5.0 cm 
  layer 3 - 5.0 cm to 10.0 cm 
 
  The depth structure in this file should match the ADEP(*) values in the fix.100 file in such a way that the boundaries for the soil layer depths can 
  be matched with the ADEP(*) values.  For example, using the file above and ADEP(1-10) values of 10, 20, 15, 15, 30, 30, 30, 30, 30, and 30

  ADEP(*) parameters in fix.100: 
  10.00000          'ADEP(1)'    
  20.00000          'ADEP(2)'    
  15.00000          'ADEP(3)'    
  15.00000          'ADEP(4)'    
  30.00000          'ADEP(5)'    
  30.00000          'ADEP(6)'    
  30.00000          'ADEP(7)'    
  30.00000          'ADEP(8)'    
  30.00000          'ADEP(9)'    
  30.00000          'ADEP(10)' 
 
  layers 1, 2 and 3 match the first 10 centimeter ADEP(1) value 
  layers 4 and 5 match the second 20 centimeter ADEP(2) value 
  layer 6 matches the third 15 centimeter ADEP(3) value 
  layer 7 matches the fourth 15 centimeter ADEP(4) value 
  layers 8 and 9 match the first 30 centimeter ADEP(5) value 
  layers 10 and 11 match the second 30 centimeter ADEP(6) value 
  layer 12 matches the third 30 centimeter ADEP(7) value 
  ADEP(8-10) are not used
  ```

  * input soil data
  * start inputting your weather data, (you need data for every day you want to simulate)

  ``` json
  {
        "simulation": [
            {
                "site": ".100 file inputs"
            },
            {
                "soils": [
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    },
                    {
                        "udsl": 0,
                        "ldsl": 1,
                        "bdsl": 0.80,
                        "fcsl": 0.80,
                        "wpsl": 0.80,
                        "ecsl": 0,
                        "frsl": 0.50,
                        "fssl": 0.50,
                        "fcsl": 0.50,
                        "omsl": 0.50,
                        "wcsl": 0.34,
                        "hcsl": 0.32,
                        "phsl": 0.4
                    }
                ]
          },
          {
              "usexdrvrs": 0,
              "data": [
                  {
                      "dom": 1,
                      "moy": 1,
                      "year": 1,
                      "day": 1,
                      "maxTemp": 32,
                      "minTemp": 3,
                      "precip": 9.32
                  },
                  {
                      "dom": 2,
                      "moy": 1,
                      "year": 1,
                      "day": 2,
                      "maxTemp": 32,
                      "minTemp": 3,
                      "precip": 9.32
                  }
              ]
          }
      ]
  }
  ```
