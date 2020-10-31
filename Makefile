DOCKER_IMAGE_VERSION?=0.0.5
REPOSITORY=502414664542.dkr.ecr.eu-west-1.amazonaws.com/jsaito
NAME=$(REPOSITORY)/go-dev
IMAGE=$(NAME):$(DOCKER_IMAGE_VERSION)
SHORT_NAME=go-dev-$(DOCKER_IMAGE_VERSION)
COMMAND=/usr/bin/docker

MOUNT_VOLUME = /home/lupin/projects/docker-image-go-dev/volume


.PHONY: build clean daemon deploy ip push run shell start stop rm

# production
build:
	$(COMMAND) build --no-cache=true -f Dockerfile -t $(IMAGE) .

ip:
	$(COMMAND) inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(SHORT_NAME)

push:
	$(COMMAND) push $(IMAGE)

run:
	$(COMMAND) run -d --tty --name $(SHORT_NAME) -v $(MOUNT_VOLUME):/vol -p 2222:22 $(IMAGE)

# with port mapping to 2222 for ssh
daemon:
	$(COMMAND) run -d --tty --name $(SHORT_NAME) -v $(MOUNT_VOLUME):/vol -p 2222:22 $(IMAGE)

# known ttyp work-around, support 256 colors
shell:
	$(COMMAND) exec -it $(SHORT_NAME) env TERM=xterm-256color script -q -c /bin/bash /dev/null

start:
	$(COMMAND) start $(SHORT_NAME)

stop:
	$(COMMAND) stop $(SHORT_NAME)

clean: stop
	$(COMMAND) stop $(SHORT_NAME) && docker rm $(SHORT_NAME)
