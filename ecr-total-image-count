#!/bin/bash

# Function to get the image count for a specific ECR repository
get_image_count() {
    repository_name="$1"
    image_count=$(aws ecr describe-images --repository-name "$repository_name" --query 'length(imageDetails)')
    echo "$image_count"
}

# Get a list of all ECR repositories in the account
repositories=$(aws ecr describe-repositories --query 'repositories[*].repositoryName' --output text)

# Initialize a variable to store the total image count
total_image_count=0

# Iterate through each repository and get the image count
for repository in $repositories; do
    count=$(get_image_count "$repository")
    total_image_count=$((total_image_count + count))
done

# Print the total ECR image count in the account
echo "Total ECR image count in the account: $total_image_count" > ecr_image_count.txt
