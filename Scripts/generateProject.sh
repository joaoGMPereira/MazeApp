#!/bin/sh
set -e

echo "\nGenerating project"
xcodegen -q -s project.yml
echo "Done."
