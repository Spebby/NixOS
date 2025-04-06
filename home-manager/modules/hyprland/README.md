# Notes

While I've tried to make my config pretty pc-agnostic, in the interest of time,
I've had to skimp out a bit with my hyprland config. NVIDIA and laptop specific
environmental variables are not hugely frequent... but still there. I intend to
make this more flexible in the future, but for the moment, you'll have to
manually tweak some of this yourself.

## Submodules

NixOS requires that every package/module references as part of a configuration
be included in the managing git repository. Because this is a submodule, I must
manually stuff it into a "submodules" directory, so Nix knows to copy it to the
store.
