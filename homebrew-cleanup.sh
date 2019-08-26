#!/bin/sh -e

if ! which brew > /dev/null; then
	echo "Error: Homebrew not in PATH."
	exit 1
fi

BREW_CONFIG=$(brew config)
BREW_PREFIX=$(echo "$BREW_CONFIG" | grep '^HOMEBREW_PREFIX: ' | cut -d ':' -f 2 | tr -d '[:space:]')

BREW_DIR="$BREW_PREFIX/Homebrew"
TAPS_DIR="$BREW_DIR/Library/Taps"

cd "$BREW_DIR"
echo "Cleaning core homebrew installation..."
git gc --aggressive
echo

cd "$TAPS_DIR"
for subdir in */*; do
	cd $subdir
	echo "Cleaning tap $subdir..."
	git gc --aggressive
	echo
	cd ../..
done

echo "Cleaning up homebrew installs..."
brew cleanup
