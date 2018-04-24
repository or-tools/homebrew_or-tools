#!/usr/bin/env bash
set -e

set -x
brew install --HEAD --build-from-source --verbose ./or-tools.rb
brew list -v ortools
brew audit --new-formula --strict or-tools
