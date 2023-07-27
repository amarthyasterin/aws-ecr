#!/bin/bash

# Set the AWS Region where your ECR repositories are located
AWS_REGION="eu-west-2"

# List of keywords to filter repository names
keywords=("cnsl068" "docs058" "hlcc024")

# Create a text file and write the following information to it:
#   * The names of the repositories that contain "cnsl068", "docs058", or "hlcc024"
echo "Repositories containing 'cnsl068', 'docs058', or 'hlcc024':" > output.txt

for keyword in "${keywords[@]}"; do
    repositories=$(aws ecr describe-repositories --region "$AWS_REGION" --query "repositories[?contains(repositoryName, '$keyword')].repositoryName" --output json | jq -r '.[]')
    for repo in $repositories; do
        echo "  * $repo" >> output.txt

        # Set the lifecycle policy to retain only 3 images
        policy='{"rules": [{"rulePriority": 1, "description": "Keep only 3 images", "selection": {"tagStatus": "any", "countType": "imageCountMoreThan", "countNumber": 3}, "action": {"type": "expire"}}]}'
        aws ecr put-lifecycle-policy --repository-name "$repo" --lifecycle-policy-text "$policy" --region "$AWS_REGION"
    done
done

# Save the text file
cat output.txt
