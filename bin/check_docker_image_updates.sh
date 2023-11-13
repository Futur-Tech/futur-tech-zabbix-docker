#!/bin/bash

export LOG_FILE="/var/log/futur-tech-zabbix-docker_image_updates.log"
source /usr/local/bin/futur-tech-zabbix-docker/ft_util_inc_func
source /usr/local/bin/futur-tech-zabbix-docker/ft_util_inc_var

# Initialize a counter for images with updates
update_count=0

# List all running Docker containers and get their container IDs
containers=$(docker ps -q)

# Loop through each container and check for updates on its image
for container in $containers; do
    image=$(docker inspect --format='{{.Config.Image}}' $container)

    # Pull the latest version of the image
    run_cmd_nolog_noexit docker image pull $image

    # Get the ID of the running image
    running_image_id=$(docker inspect --format='{{.Image}}' $container)

    $S_LOG -s debug -d "$S_NAME" -d "$image" "$running_image_id is running_image_id"

    # Check if the running image ID is empty
    if [ -z "$running_image_id" ]; then
        $S_LOG -s err -d "$S_NAME" "Running image ID for container $container is empty."
        continue
    fi

    # Use docker image inspect to get the RepoDigests
    repo_digests=$(docker image inspect $running_image_id --format='{{index .RepoDigests 0}}')
    # Extract the repository name from the RepoDigest
    latest_image_name=$(echo $repo_digests | cut -d'@' -f1)
    latest_image_id=$(docker images --format "{{.ID}}" --filter=reference="$latest_image_name" --no-trunc | head -n 1)

    $S_LOG -s debug -d "$S_NAME" -d "$image" "$latest_image_name is latest_image_name"
    $S_LOG -s debug -d "$S_NAME" -d "$image" "$latest_image_id is latest_image_id"

    # Check if the latest image ID is empty
    if [ -z "$latest_image_id" ]; then
        $S_LOG -s err -d "$S_NAME" "Latest image ID for image $image is empty."
        continue
    fi

    if [ "$running_image_id" != "$latest_image_id" ]; then
        $S_LOG -s warn -d "$S_NAME" "A newer version of $image is available."
        update_count=$((update_count + 1))
    fi
done

# Display summary message
if [ $update_count -eq 0 ]; then
    $S_LOG -d "$S_NAME" "All images are up-to-date."
else
    $S_LOG -s warn -d "$S_NAME" "$update_count image(s) have newer versions available."
fi
