#!/bin/bash 
#
# Writing something in Lambda? 
# Use this script to monitor for saves
# and then run your code in a clone of the lambda env.
#
function_name='app'
handler_name='lambcidocker'
filename="$function_name.py"
OG_VALUE=`md5 -q $filename`
REGION=us-east-1
echo "og value is $OG_VALUE"


while :
do
  sleep 2
  TEMP_VALUE=`md5 -q $filename`  
  if [ "$TEMP_VALUE" != "$OG_VALUE" ]
  then
    echo "temp value, $TEMP_VALUE, $OG_VALUE"
    OG_VALUE=`md5 -q $filename`
    payload=$(cat example_payload.json)
    docker run --rm -v "$PWD":/var/task \
      -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
      -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
      -e AWS_REGION=$REGION \
      -e AWS_ACCOUNT_ID=$AWS_ACCOUNT_NUMBER \
      lambci/lambda:python2.7 $function_name.$handler_name
  fi
done
