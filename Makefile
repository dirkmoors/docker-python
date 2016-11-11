ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOCKER_REPO?=ditchitall/python

parse_python_version = $(shell echo $@ | sed "s/[^-]*-python-\(.*\)/\1/")

all: build push

push: push-python-2.7.12 push-python-3.5.2

build: build-python-2.7.12 build-python-3.5.2

build-%: PYTHON_VERSION=$(parse_python_version)
build-%:
	@echo "\
pythonversion: $(PYTHON_VERSION)\n\
" > data$(PYTHON_VERSION).yml
	@docker run \
		-v $(ROOTDIR)/Dockerfile.j2:/data/Dockerfile.j2 \
		-v $(ROOTDIR)/data$(PYTHON_VERSION).yml:/data/data.yml \
		sgillis/jinja2cli Dockerfile.j2 data.yml > Dockerfile
	docker build -t $(DOCKER_REPO):$(PYTHON_VERSION)-alpine .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile

push-%: PYTHON_VERSION=$(parse_python_version)
push-%:
	docker push $(DOCKER_REPO):$(PYTHON_VERSION)-alpine