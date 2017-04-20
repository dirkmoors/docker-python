# docker-python-alpine

To build the docker image for Python 2.7.13, 3.5.3 and 3.6.1:
```
$ make build
```

This will generate 3 images:
```
ditchitall/python:2.7.13-alpine
ditchitall/python:3.5.3-alpine
ditchitall/python:3.6.1-alpine
```

Then, you can use on of these as a base image or run python directly.

## Non-Root container command execution
Example
```
$ docker run -e LOCAL_USER_ID=$(id -u) -ti ditchitall/python:3.5.3-alpine bash
bash-4.3$
```
You can verify the uid to be non-root:
```
bash-4.3$ echo $(id -u)
bash-4.3$ 0
```

## Extra features
Extras integrated into the build are:
```
libressl (v2.5.3)
dependencies for Pillow, supporting JPEG, PNG, TIFF and WebP
```
