#!/usr/bin/env bash
set -euxo pipefail

## https://github.com/Homebrew/brew/issues/1742#issuecomment-277308817
#rm -f /usr/local/include/c++

sw_vers

brew --version
brew update
brew upgrade
brew --version

# list all installed taps.
brew tap
