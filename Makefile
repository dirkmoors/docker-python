ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOCKER_REPO?=ditchitall/python

parse_python_version = $(shell echo $@ | sed "s/[^-]*-python-\(.*\)/\1/")

all: build push

push: push-python-2.7.15 push-python-3.6.8 push-python-3.7.0

build: build-python-2.7.15 build-python-3.6.8 build-python-3.7.0

build-%: PYTHON_VERSION=$(parse_python_version)
build-%:
	@echo "Building for ALPINE: $(PYTHON_VERSION)"
	@echo "\
pythonversion: $(PYTHON_VERSION)\n\
" > data$(PYTHON_VERSION).yml
	@docker run \
		-v $(ROOTDIR)/Dockerfile-alpine.j2:/data/Dockerfile-alpine.j2 \
		-v $(ROOTDIR)/data$(PYTHON_VERSION).yml:/data/data.yml \
		sgillis/jinja2cli Dockerfile-alpine.j2 data.yml > Dockerfile
	docker pull python:$(PYTHON_VERSION)-alpine3.10
	docker build -t $(DOCKER_REPO):$(PYTHON_VERSION)-alpine .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile
	@echo "Building for Debian Stretch: $(PYTHON_VERSION)"
	@echo "\
pythonversion: $(PYTHON_VERSION)\n\
" > data$(PYTHON_VERSION).yml
	@docker run \
		-v $(ROOTDIR)/Dockerfile-stretch.j2:/data/Dockerfile-stretch.j2 \
		-v $(ROOTDIR)/data$(PYTHON_VERSION).yml:/data/data.yml \
		sgillis/jinja2cli Dockerfile-stretch.j2 data.yml > Dockerfile
	docker pull python:$(PYTHON_VERSION)-slim-stretch
	docker build -t $(DOCKER_REPO):$(PYTHON_VERSION)-stretch .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile

push-%: PYTHON_VERSION=$(parse_python_version)
push-%:
	docker push $(DOCKER_REPO):$(PYTHON_VERSION)-alpine
	docker push $(DOCKER_REPO):$(PYTHON_VERSION)-stretch
