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

These functions provide various utility operations related to deploying Git repositories, running commands with logging and error handling, file backup, directory creation, and file difference checking.

- `deploy_git`: Clones a Git repository and deploys it. If the repository is already cloned, it can be redeployed by passing the "deploy-again" argument.
- `run_cmd_log`: Runs a command, logs its output, and checks the exit code. If the command fails, it exits with the corresponding exit code.
- `run_cmd_nolog`: Runs a command without logging its output, but still checks the exit code. If the command fails, it exits with the corresponding exit code.
- `run_cmd_log_noexit`: Runs a command, logs its output, and checks the exit code. If the command fails, it continues without exiting.
- `run_cmd_nolog_noexit`: Runs a command without logging its output, but still checks the exit code. If the command fails, it continues without exiting.
- `bak_if_exist`: Makes a backup copy of a file if it exists.
- `mkdir_if_missing`: Creates a directory if it doesn't already exist.
- `show_bak_diff`: Shows the difference between a file and its backup (if the backup exists).
- `show_bak_diff_rm`: Shows the difference between a file and its backup (if the backup exists) and removes the backup file.
- `is_bak_diff`: Checks if a file and its backup (if the backup exists) are different.

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
