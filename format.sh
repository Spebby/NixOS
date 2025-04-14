#!/bin/bash

nix shell nixpkgs#nixfmt-rfc-style -c find . -name "*.nix" -exec nixfmt --strict {} +
nix shell nixpkgs#statix -c statix fix .
