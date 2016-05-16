#!/bin/bash
set -e

COUNT=0
DESIRED=$1

while [ $COUNT -lt $DESIRED ]; do
  ((COUNT++))
  cp /etc/init.d/go-agent /etc/init.d/go-agent-$COUNT
  sed -i "s/# Provides: go-agent$/# Provides: go-agent-$COUNT/g" /etc/init.d/go-agent-$COUNT
  ln -s /usr/share/go-agent /usr/share/go-agent-$COUNT
  cp /etc/default/go-agent /etc/default/go-agent-$COUNT
  mkdir /var/{lib,log}/go-agent-$COUNT
  chown go:go /var/{lib,log}/go-agent-$COUNT
  update-rc.d go-agent-$COUNT defaults
done
