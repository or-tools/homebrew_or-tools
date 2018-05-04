#!/usr/bin/env bash
set -ex

rm /usr/local/include/c++ # https://github.com/Homebrew/brew/issues/1742#issuecomment-277308817
brew update
# list all installed taps.
brew tap
