#!/bin/bash
#
# Descontracturador Hackatonero.
#
# Version 0.1 - 20140606
# By Juan Alberto Jolis
#

APP_PARAM=$1

if [ "$APP_PARAM" = "" ]
  then
   echo " "
   echo ' Debe pasar un parámetro de búsqueda a continuación del comnado, por ejemplo: comando "San Martín"'
   echo " "
   exit 1
fi

# Acá hay que asignar una clave del API pública de educar.
# Gestionar la clave en: http://datosabiertos.educ.ar/

APP_KEY='aca va la clave!!'

APP_QUERY='"texto":"'$APP_PARAM'"'

echo " "
echo "Realizando búsqueda..."$APP_QUERY

APP_GET_REQ='https://api.educ.ar/0.9/conectate/videos/?q={'$APP_QUERY'}&key='$APP_KEY

echo " " >  output.dat 
wget $APP_GET_REQ -O output.dat > /dev/null 2> /dev/null

APP_REQ_ID=`cat output.dat | cut -d: -f10 | cut -d, -f1`

if [ "$APP_REQ_ID" = "" ]
  then
   echo "No hay resultados de búsqueda, intente con un nuevo patrón"
   echo " "
   exit 1
fi

APP_VIDEO_DETALLE='http://api.educ.ar/0.9/conectate/videos/'$APP_REQ_ID'?key='$APP_KEY

echo " " >  output2.dat 
wget $APP_VIDEO_DETALLE -O output2.dat > /dev/null 2> /dev/null

APP_FILE_ID=`cat output2.dat | cut -d: -f11  | cut -d= -f2 | cut -d"&" -f1`


APP_STREAM='http://s.api.educ.ar/repositorio/Video/ver?file_id='$APP_FILE_ID'&rec_id='$APP_REQ_ID

vlc $APP_STREAM > /dev/null 2>/dev/null &

echo " "

exit 0
