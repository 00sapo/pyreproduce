#!/bin/env sh

thisdir=$(dirname $0)

# removing pyenv
LOCALREPO=${thisdir}/pyenv
rm -rf ${LOCALREPO}/*
rm -r .python-version

# removing __pypackages__
rm -rf __pypackages__
rm pdm.lock
rm .pdm.toml
