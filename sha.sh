# #!/bin/bash

# # Path to the file containing the repository URLs and file paths
# config_file="repo_url.txt"

# # Check if the config file exists
# if [ ! -f "$config_file" ]; then
#   echo "Error: Configuration file not found: $config_file"
#   exit 1
# fi

# # Function to fetch the latest 'rhoai' branch from a repository URL
# fetch_latest_branch_name() {
#   local repo_url="$1"
#   local latest_branch=$(git ls-remote --heads "$repo_url" | grep 'rhoai' | awk -F'/' '{print $NF}' | sort -V | tail -1)
#   if [ -z "$latest_branch" ]; then
#     echo "Error: Unable to determine the latest branch name from $repo_url."
#     exit 1
#   fi
#   echo "$latest_branch"
# }

# # Function to check SHAs and print results
# extract_names_with_att_extension() {
#  local tag="$1"
#  local repo_hash="$2"

#  json_response=$(curl -s https://quay.io/api/v1/repository/modh/$tag/tag/ | jq -r '.tags | .[:3] | map(select(.name | endswith(".att"))) | .[].name')
#  local quay_hash=$(echo "$json_response" | sed 's/^sha256-\(.*\)\.att$/\1/')
#  # echo "$quay_hash"

# if [ "$repo_hash" = "$quay_hash" ]; then
#      echo -e "\e[32mRepository SHA ($repo_hash) matches Quay SHA ($quay_hash) for tag: $tag\e[0m"
#  else
#      echo -e "\e[31mRepository SHA ($repo_hash) does NOT match Quay SHA ($quay_hash) for tag: $tag\e[0m"
#      sha_mismatch_found=1
#  fi
# }

# # Initialize a variable to keep track of SHA mismatches
# sha_mismatch_found=0

# # Main logic for processing the file and SHAs
# main() {
#   local specified_branch="${1:-}"

#   while IFS=';' read -r repo_url file_path; do
#     # Determine the branch to use: specified as argument or fetch the latest 'rhoai'
#     local branch_name="${specified_branch:-$(fetch_latest_branch_name "$repo_url")}"

#     echo "Processing $repo_url with path $file_path and branch $branch_name..."

#     # Extract the directory name from the repository URL
#     dir_name=$(basename "$repo_url" .git)

#     echo "Attempting to clone the branch '$branch_name' from '$repo_url' into directory '$dir_name'..."

#     # Clone the specified branch of the repository into a directory named after the repository
#     git clone --depth 1 -b "$branch_name" "$repo_url" "$dir_name"
#     if [ $? -ne 0 ]; then
#       echo "Error: Failed to clone branch '$branch_name' from '$repo_url'"
#       continue  # Skip to the next repository if cloning fails
#     else
#       echo "Successfully cloned the branch '$branch_name'."
#     fi

#     # Define full path to check the specified file within the cloned directory
#     full_path="$dir_name/$file_path"
#     if [ -f "$full_path" ]; then
#       echo "File found: $full_path"
#       # Read the file and extract SHAs
#       while IFS= read -r line; do
#           local name=$(echo "$line" | cut -d'=' -f1)
#           local hash=$(echo "$line" | awk -F 'sha256:' '{print $2}')
#           extract_names_with_att_extension "$name" "$hash"
#       done < "$full_path"
#     else
#       echo "File not found: $full_path"
#     fi

#     # Clean up the directory for the next iteration
#     rm -rf "$dir_name"

#   done < "$config_file"

#   # Check if any SHA mismatches were found
#   if [ "$sha_mismatch_found" -ne 0 ]; then
#       echo "One or more SHA mismatches were found."
#       exit 1
#   else
#       echo "All SHA hashes match."
#   fi
# }

# # Execute the main logic with an optional branch name
# main "$1"
