# ft-util
Library of Scripts for Futur-Tech Devs

## Install

    cd <your_repo>

    mkdir ft-util && cd ft-util && wget https://raw.githubusercontent.com/Futur-Tech/ft-util/main/deploy_ft_util && chmod +x deploy_ft_util && ./deploy_ft_util

You can edit which script you need by editing deploy_ft_util

## Update script

    ./deploy_ft_util

    for d in futur-tech-*; do $d/ft-util/deploy_ft_util ; done

# Scripts Description
## ft_util_bak-cleaner

This script will delete .BAK file older than 7 days.

> Script dependency:
> - ft_util_log

## ft_util_conf-update

Config File Updater Script

Note: comments on the same lines of a variable set in a target conf will be kept inside the target file

> Script dependency:
> - ft_util_log
> - ft_util_bak-cleaner

## ft_util_docker

Functions to help in the deployement of Docker containers.

> Script dependency:
> - ft_util_log

## ft_util_file-deploy

File deployement... todo: readme

Option **NO-BACKUP** can be specified to avoid creating a backup
Option **NO-COMPARE** can be specified to avoid showing diff result

> Script dependency:
> - ft_util_log
> - ft_util_bak-cleaner

## ft_util_inc_func

Utility functions used across Futur-Tech deployment scripts.  
They provide Git repo deployment, command execution helpers with integrated logging and error handling, backup helpers, directory creation, diff checking, variable overrides, and simple interactive helpers.

Available functions:

- `deploy_git name repo_url args deploy-again`  
  Clone or redeploy a Git repository and execute its `deploy.sh`.

- `check_required_vars var1 var2 ...`  
  Verify required boolean vars are set; exit if any missing.

- `run_cmd_log "<cmd>"`  
  Run command with full logging; exit on failure.

- `run_cmd_nolog "<cmd>"`  
  Run command silently; exit on failure.

- `run_cmd_silent "<cmd>"`  
  Silent run, logs only debug on success; exit on failure.

- `run_cmd_quiet "<cmd>"`  
  Show command output and show result only on failure; exit on failure.

- `run_cmd_log_noexit "<cmd>"`  
  Same as `run_cmd_log` but continues on failure.

- `run_cmd_nolog_noexit "<cmd>"`  
  Silent execution without exiting on failure.

- `bak_if_exist <path>`  
  Create a `.bak` copy of a file if it exists.

- `mkdir_if_missing <dir>`  
  Create directory if missing.

- `show_bak_diff <path>`  
  Show unified diff vs backup if present.

- `show_bak_diff_rm <path>`  
  Show diff then remove backup.

- `is_bak_diff <path>`  
  Return 0 if file differs from its `.bak`.

- `override_var <file> "VAR=" "value"`  
  Replace a variable value in config files.

- `override_key <file> "VAR="`  
  Generate key if missing and set it.

- `confirm "message"`  
  Prompt y/N.

- `pause`  
  Wait for Enter key.

> Script dependency:  
> - ft_util_log

## ft_util_inc_var

Basic vars used accross Futur-Tech scripts. Also declare log.

> Script dependency:
> - ft_util_log

## ft_util_kerberos

This function will generate a Kerberos ticket for a Domain Username from a keytab file located in the home directory.
If this script is run as root on a Domain Controller, it can automatically also generate a keytab.
The following variable will be exported:
- ft_util_kerberos_sambatool, its value will contain the Kerberos argument needed for the installed version of samba-tool
- KRB5CCNAME, its value is used to locate the default ticket cache (see "man klist")

## ft_util_log

Logging script

- the $LOG_DEBUG should be declared in the script which use ft_util_log in order to log debug message

- the $LOG_FILE can also contains several path separated with space

## ft_util_pkg

This script for 2 purposes:

1. check if a packet is installed
1. install packet needed if not installed

### Exemples
    ft-util/ft_util_pkg "pkg1"
    # (Return 0 if pkg1 is installed)

    ft-util/ft_util_pkg -u
    # Run apt update

    ft-util/ft_util_pkg -i "pkg1" "pkg2" "pkg3" "pkg4"
    # Install "pkg1" "pkg2" "pkg3" "pkg4".
    # Return number of packet not installed.

    ft-util/ft_util_pkg -u -i "pkg1" "pkg2" "pkg3" "pkg4"
    # Same than the previous exemple but with apt update before.

> Script dependency:
> - ft_util_log


## ft_util_sshauth

Will compile the authorized_keys files from files in authorized_keys.d/
If authorized_keys.d/ doesnt exist, the script will create it and exit

    ft-util/ft_util_sshauth "<user>" "<usergroup>"

Note: if usergroup=user then you can omit it.

> Script dependency:
> - ft_util_log

*Credit: https://rumkin.medium.com/how-to-organize-ssh-keys-access-7b822db312a8*

## ft_util_sshkey

Will generate ssh key for user and apply proper permission to .ssh folder.

    ft-util/ft_util_sshkey "user" "usergroup"

Note: if usergroup=user then you can omit it.

> Script dependency:
> - ft_util_log

## ft_util_sudoersd

Functions to help in the deployement of sudoers file in `/etc/sudoers.d/`.

> Script dependency:
> - ft_util_log

## ft_util_usrmgmt
Functions to help in the deployement of users and permissions.

> Script dependency:
> - ft_util_log
> - ft_util_inc_func
