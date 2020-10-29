#!/usr/bin/env bash
set -euxo pipefail

brew install --HEAD --only-dependencies --verbose ./or-tools.rb
brew install --HEAD --build-from-source --verbose ./or-tools.rb

brew info or-tools
brew list -v or-tools

brew audit --strict --online or-tools
