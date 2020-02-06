#!/usr/bin/env sh

export UMASK_SET=${UMASK_SET:-022}
export YACRON_CONFD=${YACRON_CONFIGD:-/etc/yacron.d/}

UMASK=$(which umask)
if [[ ! -x $UMASK ]]; then
  echo "umask binary not found"
  exit 1
fi

CONFD=$(which confd)
if [[ ! -x $CONFD ]]; then
  echo "confd binary not found"
  exit 1
fi

YACRON=$(which yacron)
if [[ ! -x $YACRON ]]; then
  echo "yacron binary not found"
  exit 1
fi

RESTIC=$(which restic)
if [[ ! -x $RESTIC ]]; then
  echo "restic binary not found"
  exit 1
fi

echo $UMASK "$UMASK_SET"
$UMASK "$UMASK_SET"

echo mkdir -p "$YACRON_CONFD"
mkdir -p "$YACRON_CONFD" > /dev/null

echo $CONFD -onetime -backend env -log-level debug
$CONFD -onetime -backend env -log-level debug || exit 1
cat /etc/yacron.d/restic.yaml

echo ${YACRON} -c ${YACRON_CONFD}
exec ${*:-${YACRON} -c ${YACRON_CONFD}}
