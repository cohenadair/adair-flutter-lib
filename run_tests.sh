#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

dirs=("$SCRIPT_DIR")
for package in "$SCRIPT_DIR"/packages/*/; do
  if [ -d "$package/test" ]; then
    dirs+=("${package%/}")
  fi
done

"$SCRIPT_DIR/../run_tests.sh" "${dirs[@]}"
