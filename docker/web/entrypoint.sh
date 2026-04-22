#!/bin/bash
set -e

NFS_SERVER="${NFS_SERVER:-nfs}"
NFS_EXPORT="${NFS_EXPORT:-/exports/files}"
MOUNT_POINT="/var/www/html/sites/default/files"

mkdir -p "$MOUNT_POINT"

echo "Waiting for NFS server ${NFS_SERVER}..."
for i in $(seq 1 30); do
  err=$(mount -t nfs -o vers=4,rw,soft,lookupcache=none "${NFS_SERVER}:${NFS_EXPORT}" "$MOUNT_POINT" 2>&1) && {
    echo "NFS mounted at ${MOUNT_POINT}"
    chown www-data:www-data "$MOUNT_POINT"
    chmod 755 "$MOUNT_POINT"
    break
  }
  echo "Attempt ${i}/30 failed: ${err}"
  if [ "$i" -eq 30 ]; then
    echo "ERROR: could not mount NFS share after 30 attempts" >&2
    exit 1
  fi
  sleep 2
done

exec "$@"
