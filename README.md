# Zabbix Monitoring Docker
Zabbix template for Docker.

The only difference with the official template is:
- Use of Active Agent
- deploy.sh to setup proper permission for **Zabbix Agent 2**
- added script to check for running images update
- added items for monitoring new images available and date for last check
- removed 7d items data history to default 90d

Works for Zabbix 6.0 Active Agent 2

## Deploy Commands

Everything is executed by only a few basic deploy scripts. 

```bash
cd /usr/local/src
git clone https://github.com/Futur-Tech/futur-tech-zabbix-docker.git
cd futur-tech-zabbix-docker

./deploy.sh 
# Main deploy script

./deploy-update.sh -b main
# This script will automatically pull the latest version of the branch ("main" in the example) and relaunch itself if a new version is found. Then it will run deploy.sh. Also note that any additional arguments given to this script will be passed to the deploy.sh script.
```

Finally import the template YAML in Zabbix Server and attach it to your host.
