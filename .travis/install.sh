#!/usr/bin/env bash
set -ex

# https://github.com/Homebrew/brew/issues/1742#issuecomment-277308817
rm -f /usr/local/include/c++

brew update

# list all installed taps.
brew tap
