{ den, lib, ... }:
let
  # Build NixOS module that appends the provided groups to currently scoped den user.
  groupsModule = groups: user: {
    nixos.users.users.${user.userName}.extraGroups = lib.flatten [ groups ];
  };
in
{
  # Usage: (my.groups "kvm") or (my.groups [ "kvm" "libvirtd" ])
  # Returns a parametric aspect that requires a 'user' context & injects that user into requested extraGroups
  my.groups =
    groups: den.lib.parametric { includes = [ ({ user, ... }: groupsModule groups user) ]; };
}
