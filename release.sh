#!/bin/bash -e

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

sudo apt-get update
sudo apt-get install golang -t stretch-backports --no-install-recommends -y

go get -u github.com/tcnksm/ghr

ghr -t ${GITHUB_TOKEN} \
    -u ${CIRCLE_PROJECT_USERNAME} \
    -r ${CIRCLE_PROJECT_REPONAME} \
    -c ${CIRCLE_SHA1} \
    -delete \
    ${KERNEL_VERSION} dist
