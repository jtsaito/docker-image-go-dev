DOCKER_IMAGE_VERSION?=0.0.3
REPOSITORY=502414664542.dkr.ecr.eu-west-1.amazonaws.com/jsaito
NAME=$(REPOSITORY)/go-dev
IMAGE=$(NAME):$(DOCKER_IMAGE_VERSION)
SHORT_NAME=go-dev-$(DOCKER_IMAGE_VERSION)

MOUNT_VOLUME=/Users/jsaito/projects/docker_volumes/docker-image-go-dev

# production
build:
	docker build --no-cache=true -f Dockerfile -t $(IMAGE) .

push:
	docker push $(IMAGE)

deploy: build push

run:
	docker run -d --tty --name $(SHORT_NAME) -v $(MOUNT_VOLUME):/vol $(IMAGE)

# known ttyp work-around, support 256 colors
shell:
	docker exec -it $(SHORT_NAME) env TERM=xterm-256color script -q -c /bin/bash /dev/null

stoprm:
	docker stop $(SHORT_NAME) && docker rm $(SHORT_NAME)
