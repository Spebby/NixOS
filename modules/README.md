# Modules

Here you'll find essentially all of my config's files.

A reminder, any folder prefixed with `_` is ignored by `import-tree`, so must be
manually imported. This is done for files not yet transitioned into a
flake-parts module.

## Potential Refactors

Some files, namely `./features/gaming.nix` and `./default.nix` are very, very
long due to their options. It may make sense to do something like the
following...

```bash
defaults/
├── default.nix
├── nixos/
│   ├── options.nix
│   └── config.nix
└── home/
    ├── options.nix
    └── config.nix
```

```nix
nixos = { pkgs, config, lib, ... }:
  let
    cfg = config.my.defaults;
    myOptions = import ./nixos/options.nix { inherit lib pkgs; };
    myConfig  = import ./nixos/config.nix  { inherit lib pkgs config cfg; };
  in
  {
    options = myOptions;
    config  = myConfig;
  };
```
