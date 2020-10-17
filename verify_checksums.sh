#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

echo

EXIT_STATUS=0
for ABI_DIR in "$DIR"/tor-binary/src/main/jniLibs/*; do
  ABI=$(echo "$ABI_DIR" | rev | cut -d '/' -f 1 | rev)
  TOR_BINARY_SHA256SUM=$(sha256sum "$ABI_DIR/libTor.so" | cut -d ' ' -f 1)
  TOR_ANDROID_BINARY_SHA256_SUM=$(sha256sum "$DIR/external/tor-android/tor-android-binary/src/main/libs/$ABI/libtor.so" | cut -d ' ' -f 1)

  echo "tor-binary $ABI: $TOR_BINARY_SHA256SUM"
  echo "tor-android-binary $ABI: $TOR_ANDROID_BINARY_SHA256_SUM"

  echo -n "SHA256SUM: "
  if [ "$TOR_BINARY_SHA256SUM" == "$TOR_ANDROID_BINARY_SHA256_SUM" ]; then
    echo "GOOD"
  else
    echo "BAD"
    EXIT_STATUS=1
  fi

  echo
done

exit $EXIT_STATUS
