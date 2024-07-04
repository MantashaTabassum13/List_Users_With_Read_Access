#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and Personal Access Token
USERNAME=$username
TOKEN=$token

# USER and REPO_NAME
REPO_OWNER=$1
REPO_NAME=$2

# Function to send a GET REQUEST
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list the users with read access to the repository
function list_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators with read access on the repository
    collaborators=$(echo "$raw_response" | jq -r '.[] | select(.permissions.pull == true) | .login')

    # Display the list of collaborators
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access to ${REPO_OWNER}/${REPO_NAME}"
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_access

