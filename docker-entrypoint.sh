#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-0}
USERNAME=${LOCAL_USERNAME:-user}
CHOWNDIRS=${CHOWNDIRS}

if [ "${WAIT_TCP}" ];
then
    IFS=',' read -r -a array <<< "${WAIT_TCP}"
    for element in "${array[@]}"
    do
        printf "waiting for open TCP port: ${element} ...\n"
        IFS=':' read -r -a HOST_PORT <<< "${element}"
        waitforit -host=${HOST_PORT[0]} -port=${HOST_PORT[1]} -timeout=20;
    done
fi


case ${USER_ID} in
   "0")
        # Run as root
        exec "$@"
        ;;
   *)
        # Run as non-root
        adduser -s /bin/bash -u ${USER_ID} -D -h /home/${USERNAME} ${USERNAME}
        export HOME=/home/${USERNAME}

        # chown dirs
        if [ "${CHOWNDIRS}" ];
        then
            IFS=',' read -r -a array <<< "${CHOWNDIRS}"
            for element in "${array[@]}"
            do
                printf "transfering directory ownership for ${element} to ${USER_ID}:${USER_ID} ...\n"
                chown -R ${USER_ID}:${USER_ID} ${element};
            done
        fi

        # Exec statement
        exec su-exec ${USERNAME} "$@"
        ;;
esac

