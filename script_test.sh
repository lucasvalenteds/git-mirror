#!/bin/sh

export REPOSITORIES_LIST=repositories_test.txt
export REPOSITORIES_DIRECTORY=repositories_test

assert_directory_exists() {
	if [ ! -d "$1" ]
	then
		printf "\nDirectory should exist: %s" "$1"
		exit 1
	fi
}

assert_directory_does_not_exists() {
	if [ -d "$1" ]
	then
		printf "\nDirectory should not exist: %s" "$1"
		exit 1
	fi
}

assert_directory_is_not_empty() {
	files=$(find "$1" -type d -name ".git" | wc --lines)

	if [ "$files" = 0 ]
	then
		printf "\nDirectory should not be empty: %s" "$1"
		exit 1
	fi
}

assert_file_exists() {
	if [ ! -f "$1" ]
	then
		printf "\nFile should exist: %s" "$1"
		exit 1
	fi
}

assert_file_does_not_exists() {
	if [ -f "$1" ]
	then
		printf "\nFile should not exist: %s" "$1"
		exit 1
	fi
}

assert_file_is_empty() {
	if [ ! "$(cat "$1")" = "" ]
	then
		printf "\nFile should be empty: %s" "$1"
		exit 1
	fi
}

assert_file_is_not_empty() {
	if [ "$(cat "$1")" = "" ]
	then
		printf "\nFile should not be empty: %s" "$1"
		exit 1
	fi
}

delete_test_workspace() {
    rm --force --recursive "$REPOSITORIES_DIRECTORY"
    rm --force "$REPOSITORIES_LIST"

    assert_directory_does_not_exists "$REPOSITORIES_DIRECTORY"
    assert_file_does_not_exists "$REPOSITORIES_LIST"
}

test_creating_file_and_directory() {
    (delete_test_workspace)

    (assert_file_does_not_exists "$REPOSITORIES_LIST")
    (assert_directory_does_not_exists "$REPOSITORIES_DIRECTORY")

    (./script.sh) > /dev/null 2>&1

    if [ "$?" ]
	then
		(assert_file_exists "$REPOSITORIES_LIST")
		(assert_file_is_empty "$REPOSITORIES_LIST")
		(assert_directory_exists "$REPOSITORIES_DIRECTORY")
		printf "PASSED: test_creating_file_and_directory\n"
		exit 0
	else
		printf "FAILED: test_creating_file_and_directory\n"
		printf "\tThe input file and output directory should be created automatically\n"
		exit 1
	fi
}

test_cloning_repository() {
    (delete_test_workspace)

    echo "github.com octocat hello-world" > "$REPOSITORIES_LIST"
    (assert_file_exists "$REPOSITORIES_LIST")
    (assert_file_is_not_empty "$REPOSITORIES_LIST")

    (./script.sh clone)

    if [ "$?" ]
	then
		(assert_file_exists "$REPOSITORIES_LIST")
		(assert_file_is_not_empty "$REPOSITORIES_LIST")
		(assert_directory_exists "$REPOSITORIES_DIRECTORY")
        (assert_directory_is_not_empty "$REPOSITORIES_DIRECTORY")
		printf "PASSED: test_cloning_repository\n"
		exit 0
	else
		printf "FAILED: test_cloning_repository\n"
		printf "\tCould not clone the repository as expected\n"
		exit 1
	fi
}

clone_repo_and_reset_last_commit() {
    username="octocat"
    repository="hello-world"
    directory="$REPOSITORIES_DIRECTORY/${username}__${repository}"

    echo "github.com octocat hello-world" > "$REPOSITORIES_LIST"
    (./script.sh clone)

    git --git-dir="$directory/.git" --work-tree="$directory" reset HEAD~
    git --git-dir="$directory/.git" --work-tree="$directory" restore -- .
}

test_syncing_repository() {
    (delete_test_workspace)
    (clone_repo_and_reset_last_commit)

    (./script.sh sync)

    if [ "$?" ]
	then
		(assert_file_exists "$REPOSITORIES_LIST")
		(assert_file_is_not_empty "$REPOSITORIES_LIST")
		(assert_directory_exists "$REPOSITORIES_DIRECTORY")
        (assert_directory_is_not_empty "$REPOSITORIES_DIRECTORY")
		printf "PASSED: test_syncing_repository\n"
		exit 0
	else
		printf "FAILED: test_syncing_repository\n"
		printf "\tCould not clone the repository as expected\n"
		exit 1
	fi
}

(test_creating_file_and_directory)
(test_cloning_repository)
(test_syncing_repository)

(delete_test_workspace)
