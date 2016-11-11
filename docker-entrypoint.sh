#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
USERNAME=${LOCAL_USERNAME:-user}

adduser -s /bin/bash -u $USER_ID -D -h ${USERNAME} ${USERNAME}
export HOME=/home/${USERNAME}

exec su-exec ${USERNAME} "$@"
