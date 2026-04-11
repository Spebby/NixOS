# https://tangled.org/quasigod.xyz/nixconfig/blob/main/modules/meta/_compat.nix

{ lib, ... }:
{
  _module.args.mkCompat =
    unstableOptions: stableOptions:
    if (lib.versionOlder lib.version "25.11pre") then stableOptions else unstableOptions;
}
