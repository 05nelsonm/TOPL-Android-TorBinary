#!/usr/bin/env bash
# /*
# * Copyright (C) 2020 Matthew Nelson
# *
# * This program is free software: you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation, either version 3 of the License, or
# * (at your option) any later version.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program.  If not, see <https://www.gnu.org/licenses/>.
# * */

# Get current directory where the script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cd "$DIR"/../external/tor-android || exit 1
git fetch || exit 1

CURRENT_BRANCH=$( git status | grep "On branch " | cut -d ' ' -f 3 )
LATEST_BRANCH=
LATEST_BRANCH_VERSION_NUM=

update_latest_branch() {
  LATEST_BRANCH="$1"
  LATEST_BRANCH_VERSION_NUM=$( echo "$1" | cut -d '-' -f 5  | head -c 7 | sed "s/[\.]//g" )
}

is_branch_newer() {
  local BRANCH_VERSION=$( echo "$1" | cut -d '-' -f 5  | head -c 7 | sed "s/[\.]//g" )

  if [ "$BRANCH_VERSION" -gt "$LATEST_BRANCH_VERSION_NUM" ]; then
    return 0
  fi
  return 1
}

is_newer_binary_available() {
  local BRANCHES=
  local BRANCH=
  mapfile -t BRANCHES < <( git branch -a | grep "remotes/origin/tor-android-binary-tor-" | cut -d '/' -f 3)

  if echo "$CURRENT_BRANCH" | grep "tor-android-binary-tor-" > /dev/null 2>&1; then
    update_latest_branch "$CURRENT_BRANCH"
  else
    update_latest_branch ${BRANCHES[0]}
  fi

  local NEWER_BINARIES_AVAILABLE=false
  for BRANCH in ${BRANCHES[*]}; do
    if is_branch_newer $BRANCH; then
      update_latest_branch $BRANCH
      NEWER_BINARIES_AVAILABLE=true
    fi
  done

  if $NEWER_BINARIES_AVAILABLE; then
    return 0
  else
    return 1
  fi
}

build() {
  git checkout "$LATEST_BRANCH" && git pull

#  rm -rf tor-android-binary/src/main/libs/*
#  echo "tor-android Library binaries deleted"
#  echo ""
#  echo "re-building"

  if ! ./tor-droid-make.sh fetch; then
    echo "Unable to fetch submodules for tor-android"
    return 1
  fi

  if ./tor-droid-make.sh build -b release; then
    echo "Build failed"
    return 1
  fi

  return 0
}

check_for_needed_environment_variables() {
  if [ -z "$ANDROID_HOME" ]; then
    echo "ANDROID_HOME environment variable not set"
    return 1
  elif [ ! -d "$ANDROID_HOME/build-tools" ]; then
    echo "$ANDROID_HOME/build-tools/ doesn't exist, check your ANDROID_HOME path"
    return 1
  fi

  if [ -z "$ANDROID_NDK_HOME" ]; then
    echo "ANDROID_NDK_HOME environment variable not set"
    return 1
  elif [ ! -f "$ANDROID_NDK_HOME/ndk-build" ]; then
    echo "$ANDROID_NDK_HOME/ndk-build doesn't exist, check your ANDROID_NDK_HOME path"
    return 1
  fi

  return 0
}

newer_binaries_available_msg() {
  echo ""
  echo "    ==========================================================="
  echo "    | ======================================================= |"
  echo "    | |                                                     | |"
  echo "    | |     A **NEWER** tor binary version is available     | |"
  echo "    | |                                                     | |"
  echo "    | ======================================================= |"
  echo "    ==========================================================="
  echo ""
}

binaries_are_up_to_date_msg() {
  echo ""
  echo "    ==================================================="
  echo "    ||           Tor binaries are up to date         ||"
  echo "    ==================================================="
  echo ""
}

display_help_message() {
  echo ""
  echo "Invalid Arguments"
  echo ""
  echo "    Arguments:"
  echo ""
  echo "        build                                           Checks for newer version and builds tor binaries"
  echo ""
  echo "        update_versions_file                            Increases TOR_BINARY_VERSION in .versions file"
  echo ""
  echo "        check_for_update                                Checks if a newer tor binary version is available"
  echo ""
  echo "        check_for_update_cron_job <email address>       Checks if a newer tor binary version is available"
  echo "                                                        and will send an email to the one defined as the"
  echo "                                                        2nd argument. Requires that you have setup on your"
  echo "                                                        server something like msmpt."
  echo ""
  echo "    Options:"
  echo ""
  echo "        --force                                         Will force a build when used as a 2nd argument"
  echo ""
}

EXIT_ARG=0
case "$1" in
  "build")

    check_for_needed_environment_variables || exit 1

    if is_newer_binary_available; then
      newer_binaries_available_msg
    else
      binaries_are_up_to_date_msg
      if [ "$2" != "--force" ]; then
        exit 0
      fi
    fi

    if ! build; then
#      git add --all
#      git stash
#      git stash drop
#      git checkout "$CURRENT_BRANCH"
#      ./tor-droid-make.sh fetch
#      git branch -D "$LATEST_BRANCH"
      EXIT_ARG=1
    fi
    ;;

  "update_versions_file")

    VERSION=$( git -C external/tor describe --tags --always | cut -d '-' -f 2 )
    sed -i "s/TOR_BINARY_VERSION.*/TOR_BINARY_VERSION=$VERSION/" "$DIR/../.versions"
    unset TOR_VERSION
    ;;

  "check_for_update")

    if is_newer_binary_available; then
      newer_binaries_available_msg
    else
      binaries_are_up_to_date_msg
    fi
    ;;

  "check_for_update_cron_job")

    # send email address in 2nd argument...
    if [ "$2" == "" ]; then
      EXIT_ARG=1
    else
      if is_newer_binary_available; then
        echo "A newer Tor Android Binary is available for building and publishing." | mail -s \
        "Tor Android Binary Update: AVAILABLE" "$2"
      fi
    fi
    ;;

  *)

    display_help_message
    EXIT_ARG=1
    ;;

esac

unset CURRENT_BRANCH LATEST_BRANCH LATEST_BRANCH_VERSION_NUM

exit $EXIT_ARG
