# docker-python-alpine

To build the docker image for Python 2.7.12 and 3.5.2:
```
$ make build
```

This will generate 2 images:
```
ditchitall/python:2.7.12-alpine
ditchitall/python:3.5.2-alpine
```

Then, you can use on of these as a base image or run python directly.

## Non-Root container command execution
Example
```
$ docker run -e LOCAL_USER_ID=$(id -u) -ti ditchitall/python:3.5.2-alpine bash
bash-4.3$
```
You can verify the uid to be non-root:
```
bash-4.3$ echo $(id -u)
bash-4.3$ 0
```