#!/usr/bin/env sh

SSH_USER="wiseadme"
SSH_HOST="158.160.0.26"

if [ -n "$1" ]; then
  SSH_USER="$1"

fi

if [ -n "$2" ]; then
  SSH_HOST="$2"

fi

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no \
  $SSH_USER@$SSH_HOST "cd proshop/ && docker-compose pull && docker-compose up -d"