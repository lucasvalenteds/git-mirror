#!/bin/sh

repositories="repositories.txt"
repositories_directory="repositories"

[ ! -d "$repositories_directory" ] && mkdir "$repositories_directory"

awk --field-separator=" " '{print $1" "$2" "$3}' "$repositories" \
    | while read -r hostname username repository
do
    url="https://$hostname/$username/$repository"
    directory="$repositories_directory/${username}__${repository}"
    git clone "$url" "$directory"
done
