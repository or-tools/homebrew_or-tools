#!/usr/bin/env bash
set -e

set -x
brew install --HEAD --build-from-source --verbose ./or-tools.rb
brew info ortools
brew list -v ortools

brew audit --strict --online or-tools
