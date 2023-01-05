# nginx-hapi-redis
Secured hapi.js web server

# Make the shell scripts executable:
'''
chmod +x ./install.sh
chmod +x ./cron_job.sh
'''

# Edit ./etc/crontab to set the correct cron_job.sh path

# Invoke the install.sh with 3 parameters: $USER domain-name user-email:
'''
sudo ./install.sh $user mydomain.com user@email.com
'''
