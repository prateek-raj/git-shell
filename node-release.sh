#!/bin/bash
# Author: Prateek Raj (r.prateek11@gmail.com)

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

rm -rf "/tmp/${DIRECTORY_NAME:?}/"
cd "/tmp" || exit
git clone --depth 1 --branch "$TAG" "$REPO"
cd "${DIRECTORY_NAME:?}/" || exit
npm i --production
npm run build

if [ ! -d "/var/www/html/${DIRECTORY_NAME:?}/" ]; then
    mkdir "/var/www/html/${DIRECTORY_NAME:?}/"
fi

case $FRAMEWORK in
"react")
    if [ ! -d "/var/www/html/${DIRECTORY_NAME:?}/build/" ]; then
        sudo mkdir "/var/www/html/${DIRECTORY_NAME:?}/build/"
    fi
    mv "/tmp/${DIRECTORY_NAME:?}/build/"* "/var/www/html/${DIRECTORY_NAME:?}/build/"
    rm -rf "/tmp/${DIRECTORY_NAME:?}/"*
    exit 1
    ;;
"express")
    if [ ! -d "/var/www/html/${DIRECTORY_NAME:?}/" ]; then
        sudo mkdir "/var/www/html/${DIRECTORY_NAME:?}/"
    fi
    mv "/tmp/${DIRECTORY_NAME:?}/"* "/var/www/html/${DIRECTORY_NAME:?}/"
    rm -rf "/tmp/${DIRECTORY_NAME:?}/"*

    npm run start:prod
    ;;
"loopback")
    if [ ! -d "/var/www/html/${DIRECTORY_NAME:?}/" ]; then
        sudo mkdir "/var/www/html/${DIRECTORY_NAME:?}/"
    fi
    mv "/tmp/${DIRECTORY_NAME:?}/"* "/var/www/html/${DIRECTORY_NAME:?}/"
    rm -rf "/tmp/${DIRECTORY_NAME:?}/"*
    npm run stop
    npm run start:prod
    ;;
*)
    exit 0
    ;;
esac
