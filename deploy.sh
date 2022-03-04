#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_var"

APP_NAME="futur-tech-zabbix-docker"
REQUIRED_PKG_ARR=( "at" )

SRC_DIR="/usr/local/src/${APP_NAME}"
SUDOERS_ETC="/etc/sudoers.d/${APP_NAME}"

# Checking which Zabbix Agent is detected and adjust include directory
$(which zabbix_agent2 >/dev/null) && ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agent2.d"
# $(which zabbix_agentd >/dev/null) && ZBX_CONF_AGENT_D="/etc/zabbix/zabbix_agentd.conf.d" This template is only for Zabbix Agent 2
if [ ! -d "${ZBX_CONF_AGENT_D}" ] ; then $S_LOG -s crit -d $S_NAME "${ZBX_CONF_AGENT_D} Zabbix Include directory not found" ; exit 10 ; fi

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

echo "
  INSTALL NEEDED PACKAGES
------------------------------------------"

$S_DIR_PATH/ft-util/ft_util_pkg -u -i ${REQUIRED_PKG_ARR[@]} || exit 1

echo "
  ZABBIX USER
------------------------------------------"

# Add zabbix user to sudo group
if getent group docker | grep -q "\bzabbix\b"; then
    $S_LOG -d $S_NAME "zabbix user is part of group sudo"
else
    usermod -aG docker zabbix
    $S_LOG -s $? -d $S_NAME "zabbix user has been added to group sudo (returned EXIT_CODE=$?)"
fi

echo "
  SETUP SUDOERS FILE
------------------------------------------"

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo "Defaults:zabbix !requiretty" | sudo EDITOR='tee' visudo --file=$SUDOERS_ETC &>/dev/null
echo "zabbix ALL=(ALL) NOPASSWD:${SRC_DIR}/deploy-update.sh" | sudo EDITOR='tee -a' visudo --file=$SUDOERS_ETC &>/dev/null

cat $SUDOERS_ETC | $S_LOG -d "$S_NAME" -d "$SUDOERS_ETC" -i 

$S_LOG -d $S_NAME -d "$SUDOERS_ETC" "==============================="

echo "
  RESTART ZABBIX LATER
------------------------------------------"

echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

$S_LOG -d "$S_NAME" "End $S_NAME"

exit