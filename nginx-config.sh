#!/bin/bash
# Author: Prateek Raj (r.prateek11@gmail.com)

DIRECTORIES=("/etc/nginx/sites-available" "/etc/nginx/conf.d")

for directory in "${DIRECTORIES[@]}"; do
    if [ -d "${directory}" ]; then
        SITES_DIRECTORY=$directory
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
echo "${DIRECTORY_NAME:?}/"*

if [ -d "${DIRECTORY_NAME}" ]; then
    exit 1
fi

rm -rf "${DIRECTORY_NAME:?}/"
git clone --depth 1 --branch "$TAG" "$REPO"

echo "Moving conf files to ${SITES_DIRECTORY}"
sudo mv "${DIRECTORY_NAME:?}/"sites-available/*.conf "${SITES_DIRECTORY}/"

echo "Checking for symlink"
if [ "$SITES_DIRECTORY" != "/etc/nginx/conf.d" ]; then
    if [ -d "/etc/nginx/sites-enabled" ]; then
        sudo rm -rf "/etc/nginx/sites-enabled/*.conf"
        for FILE in "$SITES_DIRECTORY/"*.conf; do
            sudo ln -vsfn "$FILE" "/etc/nginx/sites-enabled/"
        done
    fi
fi

echo "Removing tag files"
rm -rf "${DIRECTORY_NAME:?}"

echo "Done"
exit 0
