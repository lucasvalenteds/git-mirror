# Git Mirror

It's a Shell script to clone and sync a list of Git repositories.

The script reads a file named `repositories.txt` with hostnames, usernames and repositories separated by one space then clones or syncs their content according to the user input. All repositories are cloned via HTTPS.

## How to run

| Description | Command |
| :--- | :--- |
| Clone all repositories | `./script.sh clone` |
| Sync all repositories | `./script.sh sync` |
| Run tests | `./script_test.sh` |

## Configuration

To clone `ProjectMVP` from `johnsmith` hosted at `git.example.com` the `repositories.txt` should have the entry below.

```text
git.example.com johnsmith ProjectMVP
```

Each line of the file represents a Git repository to be cloned or synced and may contain any hostname pointing to a Git server with HTTPS enabled.

```text
git.example.com johnsmith ProjectMVP
github.com johnsmith hello_world
gitlab.com maryjane java-playground
```
