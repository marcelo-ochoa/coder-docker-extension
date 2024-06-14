all: clean extension install

ORG=mochoa
CODER_IMAGE_NAME=codercom/code-server
VERSION=4.90
MINOR=2
IMAGE_NAME=$(ORG)/coder-docker-extension
TAGGED_IMAGE_NAME=$(IMAGE_NAME):$(VERSION).${MINOR}

clean:
	-docker extension rm $(IMAGE_NAME)
	-docker rmi $(TAGGED_IMAGE_NAME)

extension:
	docker buildx build --load -t $(TAGGED_IMAGE_NAME) --build-arg VERSION=$(VERSION) --build-arg CODER_IMAGE_NAME=$(CODER_IMAGE_NAME) .

install:
	docker extension install -f $(TAGGED_IMAGE_NAME)

validate: extension
	docker extension  validate $(TAGGED_IMAGE_NAME)

update: extension
	docker extension update $(TAGGED_IMAGE_NAME)

multiarch:
	docker buildx create --name=buildx-multi-arch --driver=docker-container --driver-opt=network=host

build:
	docker buildx build --push --builder=buildx-multi-arch --platform=linux/amd64,linux/arm64 --build-arg CODER_IMAGE_NAME=$(CODER_IMAGE_NAME) --tag=$(TAGGED_IMAGE_NAME) .
