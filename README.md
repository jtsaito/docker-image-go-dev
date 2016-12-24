# docker-image-go-dev

This repo contains a `Dockerfile` for generating an image for developing in *golang*
using *vim* on *Ubuntu*.

The current version is for Ubuntu 16.04 LTS, vim 8.0 and Go 1.7.

## Container life cycle
First, copy your git configuration into your working directory: `cp ~/.gitconfig ./.gitconfig`.
Then run `make build` to build the Docker image.

Create and run a container: `make run`. (This will
start up the container in the background.)

Run `make shell` to start an interactive shell on the container.

To terminate run `make stoprm`. This will also remove the container.


## Remarks on VIM Plugins

### Neocomplete
We use [neocomplete](https://github.com/Shougo/neocomplete.vim) for auto completion.
Run `<C-x><C-o>` auto-completing (on a string in normal mode).
