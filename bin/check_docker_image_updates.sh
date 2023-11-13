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

    # Pull the latest version of the image and check for errors
    if ! docker image pull $image | $S_LOG -s debug -d "$S_NAME" -d "$image" -i; then
        $S_LOG -s err -d "$S_NAME" "Error occurred while pulling image $image."
        continue
    fi

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
    image_name=$(echo $repo_digests | cut -d'@' -f1)
    latest_image_id=$(docker images --format "{{.ID}}" --filter=reference="$image_name" --no-trunc | head -n 1)

    $S_LOG -s debug -d "$S_NAME" -d "$image" "$latest_image_id is latest_image_id"
    $S_LOG -s debug -d "$S_NAME" -d "$image" "$image_name is image_name"

    # Check if the latest image ID is empty
    if [ -z "$latest_image_id" ]; then
        $S_LOG -s err -d "$S_NAME" "$image latest image ID for image is empty."
        continue
    fi

    if [ "$running_image_id" == "$latest_image_id" ]; then
        $S_LOG -s info -d "$S_NAME" "$image is up-to-date."
    elif [ "$running_image_id" != "$latest_image_id" ]; then
        $S_LOG -s warn -d "$S_NAME" "$image has a newer version available."
        update_count=$((update_count + 1))
    fi
done

$S_LOG -d "$S_NAME" "Images with newer versions available: [${update_count}]"
