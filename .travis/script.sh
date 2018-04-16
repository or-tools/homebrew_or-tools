#!/usr/bin/env bash
set -x
set -e

brew install --build-from-source --verbose ./or-tools.rb
