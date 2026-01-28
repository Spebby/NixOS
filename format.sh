#!/usr/bin/env bash

nix shell nixpkgs#nixfmt -c find . -name "*.nix" -exec nixfmt --strict {} +
nix shell nixpkgs#statix -c statix fix .
