#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

TOR_BUILD_DIR="$DIR/../external/tor-browser-build"
TOR_OUT_DIR="$TOR_BUILD_DIR/out/tor"

function changeDir() {
  if ! cd "$1"; then
    echo "ERROR: Failed to change dirs to $1"
    exit 1
  fi
}

function checkDirExists() {
  if [[ "$1" != "" && "$1" && -d "$1" ]]; then
    return 0
  else
    return 1
  fi
}

if ! checkDirExists "$TOR_BUILD_DIR"; then
  echo "ERROR: Directory $TOR_BUILD_DIR"
  echo "ERROR: does not exists. Did you forget to initialize"
  echo "ERROR: the repo's submodules?"
fi

changeDir "$TOR_BUILD_DIR"

if checkDirExists "$TOR_OUT_DIR"; then
  rm -rf "$TOR_OUT_DIR"
fi

./rbm/rbm build tor --target release --target torbrowser-android-armv7
./rbm/rbm build tor --target release --target torbrowser-android-aarch64
./rbm/rbm build tor --target release --target torbrowser-android-x86
./rbm/rbm build tor --target release --target torbrowser-android-x86_64

changeDir "$TOR_OUT_DIR"
TEMP_DIR=$(mktemp -d -p "$DIR")
mkdir "$TEMP_DIR/jniLibs"

for DIRECTORY in "$(pwd)"/*; do
  mkdir "$DIRECTORY/tor"
  tar -xzf "$DIRECTORY/tor.tar.gz" -C "$DIRECTORY/tor"
  sleep 1
  cp -r "$DIRECTORY/tor/jniLibs/." "$TEMP_DIR/jniLibs/"
  rm -rf "$DIRECTORY/tor"
done

if ! checkDirExists "$TEMP_DIR/jniLibs"; then
  echo "ERROR: Something went wrong... jniLibs does not exist"
fi

cp -r "$TEMP_DIR/jniLibs" "$DIR/../tor-binary/src/main"
rm -rf "$TEMP_DIR"

echo "Binaries have been extracted and moved to tor-binary/src/main/jniLibs"

exit 0
