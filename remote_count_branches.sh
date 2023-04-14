#!/bin/bash

# set the GitHub organization name
ORG_NAME="org_name_here"

# initialize the page number to 1
PAGE=1

# initialize the main and master counts to 0
MAIN_COUNT=0
MASTER_COUNT=0

# loop through each page of repositories in the organization
while true; do
  # get the list of repositories on the current page
  REPO_LIST=$(gh api "/orgs/$ORG_NAME/repos?per_page=100&page=$PAGE")

  # exit the loop if the current page is empty
  if [[ $(echo "$REPO_LIST" | jq '. | length') -eq 0 ]]; then
    break
  fi

  # loop through each repository on the current page
  for REPO_NAME in $(echo "$REPO_LIST" | jq -r '.[].full_name'); do
    # get the default branch name for the repository
    DEFAULT_BRANCH=$(gh api repos/$REPO_NAME | jq -r '.default_branch')

    # check if the default branch is main or master
    if [ "$DEFAULT_BRANCH" = "main" ]; then
      # increment the main count
      ((MAIN_COUNT++))
    elif [ "$DEFAULT_BRANCH" = "master" ]; then
      # increment the master count
      ((MASTER_COUNT++))
    else
      # print the repository name and default branch
      echo "$REPO_NAME: $DEFAULT_BRANCH"
    fi
  done

  # increment the page number
  ((PAGE++))
done

# print the total counts
echo "Total number of repositories in $ORG_NAME using main branch: $MAIN_COUNT"
echo "Total number of repositories in $ORG_NAME using master branch: $MASTER_COUNT"

