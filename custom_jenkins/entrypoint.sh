#!/bin/sh
set -eu

SOCK="/var/run/docker.sock"
if [ -S "$SOCK" ]; then
  SOCK_GID="$(stat -c %g "$SOCK" 2>/dev/null || true)"
  if [ -n "$SOCK_GID" ]; then
    if getent group docker >/dev/null 2>&1; then
      groupmod -g "$SOCK_GID" docker 2>/dev/null || true
    else
      groupadd -g "$SOCK_GID" docker
    fi
    usermod -aG docker jenkins || true
  fi
fi

exec /usr/local/bin/jenkins.sh "$@"
