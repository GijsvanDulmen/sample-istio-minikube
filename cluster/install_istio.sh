#!/bin/bash

ISTIO_VERSION=$1

set -e exit

# Determines the operating system.
OS="$(uname)"
case $OS in
  Darwin)
    OSEXT="osx"
    ;;
  linux|Linux)
    OSEXT="linux"
    ;;
  MINGW64* )
    OSEXT="win"
    ;;
  *)
    echo "Your ${OS} is not supported."
    exit 1
    ;;
esac

##### ISTIO INSTALLATION THROUGH OPERATOR #####

## Download istio if not already downloaded

if [  ! -d "./istio-${ISTIO_VERSION}" ]
then
  case $OSEXT in
    "linux"|"osx")
       echo "Installing Istio version ${ISTIO_VERSION}"
       curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
       ;;
    "win")
       NAME="istio"-$ISTIO_VERSION
       URL="https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-${OSEXT}.zip"
       echo "Installing Windows Istio"
       printf "\nDownloading %s from %s ..." "$NAME" "$URL"
       if ! curl -o /dev/null -sIf "$URL"; then
         printf "\n%s is not found, please specify a valid ISTIO_VERSION\n" "$URL"
         exit
       fi
       curl -fsLO "$URL"
       filename="istio-${ISTIO_VERSION}-${OSEXT}.zip"
       unzip "${filename}"
       rm "${filename}"
       ;;
  esac
else
  echo "Istio has already been installed!"
fi


