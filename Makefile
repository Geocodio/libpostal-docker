.PHONY: default build deploy run

default: build

org = geocodio
name = libpostal-docker

build:
	docker build -t $(org)/$(name) .

deploy:
	docker push $(org)/$(name)

run:
	docker run --rm --name=$(name) $(tag)
