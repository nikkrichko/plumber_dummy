docker stop $(docker ps --filter ancestor=plumber_auth_ssl -a -q)
docker rm $(docker ps --filter ancestor=plumber_auth_ssl -a -q)

DATE_VAR=$(date +"%d%m.%H%M%S")
echo $DATE_VAR


docker build -t plumber_auth_ssl:$DATE_VAR -t plumber_auth_ssl:latest .
docker run --rm -p 80:80 -p 443:443 -p 8000:8000 plumber_auth_ssl
