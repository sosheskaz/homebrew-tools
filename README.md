# Homebrew Tools

Tools I make for homebrew.

## Homebrew-cleanup.sh

This script will attempt to reduce the size of your homebrew installation. It is quite aggressive,
and running it often will generally be more trouble than it's worth, but it can be helpful to run
occasionally to manage the size of your installation. It does a few things:

* Clean up **all** homebrew cached formulae.
* Aggressively garbage-collect the homebrew installation's git repository.
* Aggressively garbage-collect all homebrew taps.
