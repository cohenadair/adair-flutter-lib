#!/usr/bin/env bash

protoc --dart_out=. adair_flutter_lib.proto

# Relative paths, for whatever reason, don't seem to work with --dart_out, so we move the generated files.
mv *.dart ../lib/model/gen/