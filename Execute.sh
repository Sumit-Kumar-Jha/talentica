#!/bin/sh
./bin/startup.sh &
./cloud_sql_proxy -instances=sumit-personal-space:us-central1:petclinic=tcp:3306 -credential_file=/cloudsql/key.json