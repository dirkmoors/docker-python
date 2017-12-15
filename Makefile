ROOTDIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DOCKER_REPO?=ditchitall/python

parse_python_version = $(shell echo $@ | sed "s/[^-]*-python-\(.*\)/\1/")

all: build push

push: push-python-2.7.13 push-python-3.5.2 push-python-3.6.1

build: build-python-2.7.13 build-python-3.5.2 build-python-3.6.1

build-%: PYTHON_VERSION=$(parse_python_version)
build-%:
	@echo "\
pythonversion: $(PYTHON_VERSION)\n\
gpgkeys: "C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF 97FC712E4C024BBEA48A61ED3A5CA953F73C700D 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D"\n\
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
