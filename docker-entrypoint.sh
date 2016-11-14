#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-0}
USERNAME=${LOCAL_USERNAME:-user}

case ${USER_ID} in
   "0")
        # Run as root
        exec "$@"
        ;;
   *)
        # Run as non-root
        adduser -s /bin/bash -u ${USER_ID} -D -h /home/${USERNAME} ${USERNAME}
        export HOME=/home/${USERNAME}
        chown -R ${USER_ID}:${USER_ID} ${SRC_DIR}
        exec su-exec ${USERNAME} "$@"
        ;;
esac

