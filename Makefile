DOCKER_IMAGE_VERSION?=0.0.3
REPOSITORY=502414664542.dkr.ecr.eu-west-1.amazonaws.com/jsaito
NAME=$(REPOSITORY)/go-dev
IMAGE=$(NAME):$(DOCKER_IMAGE_VERSION)
SHORT_NAME=go-dev-$(DOCKER_IMAGE_VERSION)

# production
build:
	docker build --no-cache=true -f Dockerfile -t $(IMAGE) .

push:
	docker push $(IMAGE)

deploy: build push

run:
	docker run -d --tty \
	--volume /Users/jsaito/projects/babbel/terraform:/projects/src/github.com/hashicorp/terraform  \
	--volume /Users/jsaito/projects/babbel/babbel.infrastructure:/projects/src/babbel.infrastructure \
	--cpuset-cpus="0-3" \
	--cpu-period=100000 \
	--cpu-quota=400000 \
	--name $(SHORT_NAME) $(IMAGE)

# known ttyp work-around, support 256 colors
shell:
	docker exec -it $(SHORT_NAME) env TERM=xterm-256color script -q -c /bin/bash /dev/null

rm:
	docker rm -f $(SHORT_NAME)
