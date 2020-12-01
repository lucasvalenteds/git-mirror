#!/bin/sh

repositories_list="repositories.txt"
repositories_directory="repositories"

[ ! -f "$repositories_list" ] && touch "$repositories_list"
[ ! -d "$repositories_directory" ] && mkdir "$repositories_directory"

clone() {
    awk --field-separator=" " '{print $1" "$2" "$3}' "$repositories_list" \
        | while read -r hostname username repository
        do
            url="https://$hostname/$username/$repository"
            directory="$repositories_directory/${username}__${repository}"
            git clone "$url" "$directory"

        done
}

synchronize() {
    for directory in "$repositories_directory"/*
    do
        printf "Synchronizing %s\n" "$directory"

        git --git-dir="$directory/.git" pull
    done
}

operation="$1"

case "$operation" in
    clone | synchronize)
        "$operation"
        exit 0
        ;;
    *)
        printf "Unknown operation %s\n" "$operation"
        printf "Usage: ./script.sh <clone|synchronize>\n"
        exit 1
        ;;
esac

