#!/bin/bash
# Author: Prateek Raj (r.prateek11@gmail.com)

DIRECTORIES=("/etc/nginx/sites-available" "/etc/nginx/conf.d")

for directory in "${DIRECTORIES[@]}"; do
    if [ -d "${directory}" ]; then
        SITES_DIRECTORY=directory
        break
    fi
done

if [ "$SITES_DIRECTORY" == "" ]; then
    echo "nginx not installed 😑"
    exit 1
fi

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

echo "Fetching tag $TAG 💪"
DIRECTORY_NAME=${REPO##*/}
DIRECTORY_NAME=${DIRECTORY_NAME%.*}

rm -rf "${DIRECTORY_NAME:?}/"*
git clone --depth 1 --branch "$TAG" "$REPO"
cd "${DIRECTORY_NAME:?}/" || exit 1

mv sites-available $SITES_DIRECTORY

if [ "$SITES_DIRECTORY" != "/etc/nginx/conf.d" ]; then
    if [ ! -d "/etc/nginx/sites-enabled" ]; then
        exit 1
    fi

    rm -rf "/etc/nginx/sites-enabled/*"
    cp "sites-available/*" $SITES_DIRECTORY
    link -vsfn "${SITES_DIRECTORY}/*" "/etc/nginx/sites-enabled/"
fi
