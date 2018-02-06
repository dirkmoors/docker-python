ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOCKER_REPO?=ditchitall/python

parse_python_version = $(shell echo $@ | sed "s/[^-]*-python-\(.*\)/\1/")

all: build push

push: push-python-2.7.14 push-python-3.5.4 push-python-3.6.4

build: build-python-2.7.14 build-python-3.5.4 build-python-3.6.4

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
	docker build -t $(DOCKER_REPO):$(PYTHON_VERSION)-alpine .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile
	@echo "Building for Debian JESSIE: $(PYTHON_VERSION)"
	@echo "\
pythonversion: $(PYTHON_VERSION)\n\
" > data$(PYTHON_VERSION).yml
	@docker run \
		-v $(ROOTDIR)/Dockerfile-jessie.j2:/data/Dockerfile-jessie.j2 \
		-v $(ROOTDIR)/data$(PYTHON_VERSION).yml:/data/data.yml \
		sgillis/jinja2cli Dockerfile-jessie.j2 data.yml > Dockerfile
	docker build -t $(DOCKER_REPO):$(PYTHON_VERSION)-jessie .
	@rm data$(PYTHON_VERSION).yml
	@rm Dockerfile

push-%: PYTHON_VERSION=$(parse_python_version)
push-%:
	docker push $(DOCKER_REPO):$(PYTHON_VERSION)-alpine
	docker push $(DOCKER_REPO):$(PYTHON_VERSION)-jessie
