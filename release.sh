#!/bin/bash -e

API_URL="https://api.github.com/repos/tcnksm/ghr/releases/latest"
TAG=$(curl -s $API_URL | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
DOWNLOAD_URL=$(curl -s $API_URL | grep "browser_download_url" | grep "linux" | grep "amd64" | cut -d '"' -f 4)

curl -kLs $DOWNLOAD_URL | sudo -E tar zxf - -C /usr/local/bin/ ghr_${TAG}_linux_amd64/ghr --strip-components 1

mkdir dist
cp linux-firmware-image*.deb dist/ 2>/dev/null || :
cp linux-headers*.deb dist/ 2>/dev/null || :
cp linux-image*.deb dist/ 2>/dev/null || :
cp linux-libc-dev*.deb dist/ 2>/dev/null || :

ghr -t $GITHUB_TOKEN \
    -u $CIRCLE_PROJECT_USERNAME \
    -r $CIRCLE_PROJECT_REPONAME \
    -c $CIRCLE_SHA1 \
    -n $KERNEL_VERSION \
    -delete \
    $KERNEL_VERSION dist
