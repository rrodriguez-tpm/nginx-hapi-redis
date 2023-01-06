# **nginx-hapi-redis**
This is a hapi.js web-app and ancillary files that can be used as a template to obtain a valid certificate using certbot in an automated way.

This solution contains two phases. Phase 1 obtains a valid certificate the first time and places it in a folder accessible to 

**Phase 1:**
    <ul>
    <li>run docker-compose-initiate up with the initiation configuration file</li>
    <li>obtain a certificate using Certbot and store it in a folder on the host system</li>
    <li>run docker-compose down to finish the initiation phase</li>
    </ul>

**Phase 2:**
    <ul>
    <li>create a cron job for renewing the certificate with Certbot and reloading NGINX</li>
    <li>run docker-compose up -d with the web-app configuration file</li>
    </ul>


## *To run this example:*
### Make the shell scripts executable:
```bash
chmod +x ./install.sh
chmod +x ./cron_job.sh
```

### Edit ./etc/crontab to set the correct cron_job.sh path

### Invoke the install.sh with 3 parameters: $USER domain-name user-email:
```bash
sudo ./install.sh $USER mydomain.com user@email.com
```

### Confirm that the containers are running and that the site is accessible using https
```
CONTAINER ID   IMAGE                  COMMAND                  CREATED        STATUS        PORTS                                                                      NAMES
ed0f5d2c300a   nginx:latest           "/docker-entrypoint.…"   22 hours ago   Up 22 hours   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   nginx
d65ae6f97798   nginx-hapi-redis_web   "docker-entrypoint.s…"   22 hours ago   Up 22 hours                                                                              nginx-hapi-redis_web_1
5cc54bba2b8f   redis:7.0.7-alpine     "docker-entrypoint.s…"   22 hours ago   Up 22 hours   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp                                  nginx-hapi-redis_redis_1
```

### Confirm that the cron job has been created:
```
crontab -l
# m h  dom mon dow   command
0 5  * * *  /home/touchpointmed/nginx-hapi-redis/cron_job.sh
```

### To shutdown the application:
```
docker-compose -f ./docker-compose.yaml down
```

### Remove the cron job:
```
crontab -r
```

## *To adapt this to your own web-app:*
### Only modify docker-compose.yaml by replacing the web and redis services with your own web-app services
### Edit the ./etc/crontab as it is indicated above
### Invoke the install.sh with 3 parameters: $USER domain-name user-email:
```bash
sudo ./install.sh $USER mydomain.com user@email.com
```
### To update a new version of your web-app, start by stopping the containers:
```
docker-compose -f ./docker-compose.yaml down
```
### Deploy the new images and start the web-app:
```
docker-compose -f ./docker-compose.yaml up -d
```