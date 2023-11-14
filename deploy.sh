#!/usr/bin/env bash

source "$(dirname "$0")/ft-util/ft_util_inc_func"
source "$(dirname "$0")/ft-util/ft_util_inc_var"
source "$(dirname "$0")/ft-util/ft_util_sudoersd"
source "$(dirname "$0")/ft-util/ft_util_usrmgmt"

app_name="futur-tech-zabbix-docker"
required_pkg_arr=("at")

bin_dir="/usr/local/bin/${app_name}"
src_dir="/usr/local/src/${app_name}"

# Checking which Zabbix Agent is detected and adjust include directory
$(which zabbix_agent2 >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agent2.d"
# $(which zabbix_agentd >/dev/null) && zbx_conf_agent_d="/etc/zabbix/zabbix_agentd.conf.d" This template is only for Zabbix Agent 2
if [ ! -d "${zbx_conf_agent_d}" ]; then
  $S_LOG -s crit -d $S_NAME "${zbx_conf_agent_d} Zabbix Include directory not found"
  exit 10
fi

$S_LOG -d $S_NAME "Start $S_DIR_NAME/$S_NAME $*"

echo "
  INSTALL NEEDED PACKAGES & FILES
------------------------------------------"

$S_DIR_PATH/ft-util/ft_util_pkg -u -i ${required_pkg_arr[@]} || exit 1

mkdir_if_missing "${bin_dir}"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/bin/" "${bin_dir}"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_log" "${bin_dir}/ft_util_log"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_inc_var" "${bin_dir}/ft_util_inc_var"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/ft-util/ft_util_inc_func" "${bin_dir}/ft_util_inc_func"
$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/etc.zabbix/${app_name}.conf" "${zbx_conf_agent_d}/${app_name}.conf"
enforce_security exec "$bin_dir" zabbix

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
  SETUP SCHEDULED TASK
------------------------------------------"

$S_DIR/ft-util/ft_util_file-deploy "$S_DIR/etc.cron.d/${app_name}" "/etc/cron.d/${app_name}" "NO-BACKUP"

echo "
  SETUP SUDOERS FILE
------------------------------------------"

bak_if_exist "/etc/sudoers.d/${app_name}"
sudoersd_reset_file $app_name zabbix
sudoersd_addto_file $app_name zabbix "${src_dir}/deploy-update.sh"
show_bak_diff_rm "/etc/sudoers.d/${app_name}"

echo "
  RESTART ZABBIX LATER
------------------------------------------"

echo "systemctl restart zabbix-agent*" | at now + 1 min &>/dev/null ## restart zabbix agent with a delay
$S_LOG -s $? -d "$S_NAME" "Scheduling Zabbix Agent Restart"

exit
