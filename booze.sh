#!/bin/sh -e

if ! which brew > /dev/null; then
	echo "Error: Brew not present"
	exit 1
fi

brew update
brew upgrade
brew cask upgrade
brew cleanup
