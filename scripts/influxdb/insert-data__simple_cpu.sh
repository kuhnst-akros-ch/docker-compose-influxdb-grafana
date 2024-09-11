#!/usr/bin/env bash

set -e

INFLUX_HOST="http://localhost:8086"
ORG="docs"
BUCKET="officialgazette"
TOKEN="kXakABtM0PsKphM4ISCJ3Q5YHIIZ5FGK51QlTgtc8RxyI1ZJ0Ad-QlSIj5csvJNmcYtK-ZFHA3X_i76adxURsQ=="
PRECISION="s"

# Data (mock data for CPU usage)
MEASUREMENT="cpu"
HOST="serverA"
REGION="us_west"
# VALUE=0.64
VALUE="0.$RANDOM"

# Timestamp (Unix time)
TIMESTAMP=$(date +%s)

echo "$MEASUREMENT,host=$HOST,region=$REGION value=$VALUE $TIMESTAMP"

DATA="$MEASUREMENT,host=$HOST,region=$REGION value=$VALUE $TIMESTAMP"

# Insert data into InfluxDB
# curl -i -XPOST "$INFLUX_HOST/api/v2/write?orgID=708866f55854f41b&bucket=$BUCKET&precision=$PRECISION" \
curl -i -XPOST "$INFLUX_HOST/api/v2/write?org=$ORG&bucket=$BUCKET&precision=$PRECISION" \
  --header "Authorization: Token $TOKEN" \
  --data-raw "$DATA"

