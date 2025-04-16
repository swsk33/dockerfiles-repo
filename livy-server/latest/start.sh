#!/bin/sh
${LIVY_HOME}/bin/livy-server start
tail -f ${LIVY_HOME}/logs/$(ls ${LIVY_HOME}/logs | grep '\.out$')
