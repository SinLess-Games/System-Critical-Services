#!/bin/bash

# Check if a length is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <password_length>"
  exit 1
fi

# Generate a password of the specified length
LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()-_=+{}[]<>?' </dev/urandom | head -c "$1"
echo
