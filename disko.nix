# /etc/nixos/disko.nix
{ config, pkgs, lib, ... }:

{
  # Import the Disko module
  imports = [ pkgs.nixosModules.disko ];

  # Disko configuration
  diskConfig = {
    # nvme1n1 disk partitioning configuration
    nvme1n1 = {
      partitions = [
        { name = "/boot"; size = 512; fs = "vfat"; label = "BOOT"; options = [ "fmask=0022" "dmask=0022" ]; }
        { name = "/"; size = 10000; fs = "ext4"; label = "ROOT"; }
        { name = "/home"; size = 20000; fs = "ext4"; label = "HOME"; }
        { name = "/nix"; size = 10000; fs = "ext4"; label = "NIX"; }
      ];
    };
  };

  # Filesystems and mount points
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX";
      fsType = "ext4";
    };
  };
}

