#!/bin/bash

# Output file path
output_file="./ecr_repositories_with_more_than_2_images.txt"

# Create a new empty output file
> "$output_file"

# Get a list of all ECR repositories in the AWS account
repositories=$(aws ecr describe-repositories --query 'repositories[].repositoryName' --output text)

# Loop through each repository and list all image tags
for repository in $repositories; do
    echo "Repository: $repository"

    # List all image tags in the repository
    all_image_tags=$(aws ecr list-images --repository-name "$repository" --query 'imageIds[].imageTag' --output text)

    # Count the number of images in the repository
    image_count=$(echo "$all_image_tags" | wc -w)

    if [ "$image_count" -gt 2 ]; then
        echo "   This repository has more than 2 images." >> "$output_file"
        echo "Repository: $repository" >> "$output_file"
        echo "Number of Images: $image_count" >> "$output_file"
        echo >> "$output_file"
    fi
done

echo "Script execution completed. Results saved to $output_file."
