#!/usr/bin/env bash
set -ex
# https://github.com/Homebrew/brew/issues/1742#issuecomment-277308817
rm -f /usr/local/include/c++

sw_vers

brew --version
brew update
brew upgrade
brew --version

# see https://github.com/travis-ci/travis-ci/issues/10275
brew install gcc || brew link --overwrite gcc
brew install make ccache

# list all installed taps.
brew tap
