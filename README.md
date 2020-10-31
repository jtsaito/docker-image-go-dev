# docker-image-go-dev

This repo contains a `Dockerfile` for generating an image for developing in *golang*
using *vim* on *Ubuntu*.

The current version is for Ubuntu 20.04 LTS, vim 8.2 and Go 1.15.

## Container life cycle
First, copy your git configuration into your working directory: `cp ~/.gitconfig ./.gitconfig`.
Then run `make build` to build the Docker image.

Create and run a container: `make run`. (This will
start up the container in the background.)

Run `make shell` to start an interactive shell on the container.

To terminate run `make stoprm`. This will also remove the container.


## Starting daemon

The container can be setup to run on the host and be made available to the network by ssh.

Specify an `authorized_key` file to ssh into the container as root. Additionally an ssh user
is defined for which you can set user name and password in the dockerfile.

Then start the docker container as follows.

```
make run
```

## Setup Docker hosts' .ssh/config


The makefile `run`s the container on port 2222 by default.

On the Docker host, configure your ssh client.

```
# dev Docker container
Host godev
  HostName 172.17.0.2  # container's ip
  StrictHostKeyChecking no
  User root  # or SSH user defined in Dockerfile
  Port 2222
```

To find out the container IP run:

```
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <name-of-container>
```

Now you can `ssh godev` into the container.


### Container as a Systemd service

First, `make build` the service, then configure your service in a file like vi `/etc/systemd/system/go-dev.service`

```
[Unit]
Description=Go Dev container
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
TimeoutStartSec=0
ExecStart=make --file <PATH_TO_PROJECT>/docker-image-go-dev/Makefile start

[Install]
WantedBy=default.target
```

Next reload systemd with `systemctl daemon-reload` and finally enable and start the service.

```
systemctl enable go-dev.service
```

```
systemctl start go-dev.service
```


## Remarks on VIM Plugins

### Neocomplete
We use [neocomplete](https://github.com/Shougo/neocomplete.vim) for auto completion.
Run `<C-x><C-o>` auto-completing (on a string in normal mode).
