database_without_protocol=$(echo "$DATABASE_URL" | cut -c 9-)
export BACKEND="postgresql$database_without_protocol"
export HEROKU_PORT=$(echo "$PORT")

if [[ $PORT -eq 5000 ]]
then
  export MLFLOW_PORT=4000
else
  export MLFLOW_PORT=5000
fi

envsubst '$HEROKU_PORT,$MLFLOW_PORT' < /etc/nginx/sites-available/default/nginx.conf_template > /etc/nginx/sites-available/default/nginx.conf

htpasswd -bc /etc/nginx/.htpasswd $BASIC_AUTH_USER $BASIC_AUTH_PASSWORD

killall nginx

mlflow ui --port $MLFLOW_PORT  --host 127.0.0.1 &

nginx -g 'daemon off;' -c /etc/nginx/sites-available/default/nginx.conf