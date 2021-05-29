#!/bin/bash
# Author : Prateek Raj (r.prateek11@gmail.com)
# Script follows here:

echo "Git Repository URL(git@github.com:xyz/abc.git): "
read -r REPO

if [ "$REPO" == "" ]; then
    echo "Repository url not given 😑"
    exit 1
fi

echo "Release Tag(v0.0.1, 1.1.1): "
read -r TAG

if [ "$TAG" == "" ]; then
    echo "Tag not given 🥺"
    exit 1
fi

echo "Application Framework(react, express, loopback): "
read -r FRAMEWORK

echo "Fetching tag $TAG 💪"
DIRECTORY_NAME=${REPO##*/}
DIRECTORY_NAME=${DIRECTORY_NAME%.*}

rm -rf "${DIRECTORY_NAME:?}/"*
git clone --depth 1 --branch "$TAG" "$REPO"
cd "${DIRECTORY_NAME:?}/" || exit
npm i
npm run build

case $FRAMEWORK in
"react")
    exit 1
    ;;
"express")
    npm run start:prod
    ;;
"loopback")
    npm run stop
    npm run start:prod
    ;;
*)
    exit 0
    ;;
esac
