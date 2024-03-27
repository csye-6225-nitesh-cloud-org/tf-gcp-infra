#!/bin/bash

cat > /home/csye6225/webapp/.env << End
NODE_ENV=development
DB_HOST=${db_host}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
DB_NAME=${db_name}
DB_PORT=5432
PORT=${PORT_WEBAPP}
HOSTNAME=localhost
PUB_SUB_TOPIC=${PUB_SUB_TOPIC}
GCP_PROJECT_ID=${GCP_PROJECT_ID}
End