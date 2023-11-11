#!/bin/bash

export LOG_FILE="/var/log/futur-tech-zabbix-docker_image_updates.log"
source /usr/local/bin/futur-tech-zabbix-docker/ft_util_inc_var

# Initialize a counter for images with updates
update_count=0

# List all running Docker containers and get their image names
containers=$(docker ps --format "{{.Image}}")

# Loop through each image and check for updates
for image in $containers; do
    $S_LOG -s debug -d "$S_NAME" "Checking updates for $image..."

    # Pull the latest version of the image
    docker pull $image | $S_LOG -s debug -d $S_NAME -d "$image" -i

    # Compare the image ID of the running container with the latest image ID
    running_image_id=$(docker images --format "{{.ID}}" --filter=reference="$image")
    latest_image_id=$(docker images --format "{{.ID}}" --filter=reference="$image" | head -n 1)

    $S_LOG -s debug -d "$S_NAME" -d "$image" "$running_image_id is running_image_id"
    $S_LOG -s debug -d "$S_NAME" -d "$image" "$latest_image_id is latest_image_id"

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
