#!/usr/bin/env bash
set -e

set -x
brew install --build-from-source --verbose ./or-tools.rb
brew audit --new-formula --strict or-tools
