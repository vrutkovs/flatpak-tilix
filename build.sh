#!/bin/sh

set -eux

rm -rf app
flatpak-builder --ccache --require-changes --repo=repo --subject="Nightly build of Terminix, `date`" app terminix.json

flatpak build-update-repo --prune --prune-depth=20 repo

# The following commands should be performed once
flatpak --user remote-add --no-gpg-verify nightly-terminix ./repo || true
flatpak --user -v install nightly-terminix com.gexperts.Terminix || true

flatpak update --user com.gexperts.Terminix
