DOCKER_IMAGE_VERSION?=0.0.1
REPOSITORY=502414664542.dkr.ecr.eu-west-1.amazonaws.com/jsaito
NAME=$(REPOSITORY)/go-dev
IMAGE=$(NAME):$(DOCKER_IMAGE_VERSION)
SHORT_NAME=go-dev

# production
build:
	docker build --no-cache=true -f Dockerfile -t $(IMAGE) .

push:
	docker push $(IMAGE)

deploy: build push

run:
	docker run -d --tty --name $(SHORT_NAME) $(IMAGE)

dev-run:
	docker exec -it $(IMAGE) "/bin/bash"

shell:
	docker exec -it $(SHORT_NAME) "/bin/bash"

stoprm:
	docker stop $(SHORT_NAME) && docker rm $(SHORT_NAME)
