top@{ __findFile, self, ... }:
# `self` is bound here at the top level so perSystem can close over it.
# nixosConfigurations is a top-level flake attr (not per-system), so we
# cannot use self' — instead we capture self from the outer scope.
{
  # ── VPS host definition ────────────────────────────────────────────────────
  # Builds a bootable ISO suitable for uploading to a VPS / cloud provider.
  # The ISO is exposed as packages.x86_64-linux.vps-iso and can be built with:
  #
  #   nix build .#vps-iso
  #
  # It reuses the QEMU guest config (services.qemuGuest, spice, …) defined in
  # modules/system/virtualisation.nix so the image boots correctly inside QEMU-
  # based hypervisors (KVM, QEMU/KVM VPS hosts, etc.).
  # ──────────────────────────────────────────────────────────────────────────

  den.hosts.x86_64-linux.vps = { };

  den.aspects.vps = {
    includes = [
      <my/ssh/server>
      <my/networking>
      <my/desktops/cosmic>
      <my/virt/qemu>
    ];

    nixos =
      {
        pkgs,
        lib,
        modulesPath,
        ...
      }:
      {
        imports = [
          # Pull in the upstream ISO image module so the system builds as a
          # bootable ISO rather than a regular NixOS configuration.
          "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
          ../_common
        ];

        # ── ISO metadata ───────────────────────────────────────────────────
        image.fileName = lib.mkDefault "nixos-vps.iso";
        isoImage.squashfsCompression = "zstd -Xcompression-level 6";

        # ── Boot ───────────────────────────────────────────────────────────
        boot = {
          # GRUB in EFI + BIOS-compat mode covers most VPS providers.
          loader.grub = {
            device = lib.mkForce "nodev";
            efiSupport = lib.mkForce true;
            efiInstallAsRemovable = lib.mkForce true;
          };

          # Cloud / QEMU hypervisors commonly present virtio block devices.
          initrd.availableKernelModules = [
            "virtio_pci"
            "virtio_scsi"
            "virtio_blk"
            "virtio_net"
            "ahci"
            "xhci_pci"
          ];

          kernelModules = [
            "kvm-intel"
            "kvm-amd"
          ];
        };

        # ── Networking ─────────────────────────────────────────────────────
        # Simple DHCP on every interface – sufficient for cloud first-boot.
        networking = {
          hostName = "vps";
          useDHCP = lib.mkForce false; # handled by systemd-networkd below
          useNetworkd = true;
          networkmanager.enable = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [ 22 ];
          };
        };

        systemd.network = {
          enable = true;
          networks."10-uplink" = {
            matchConfig.Name = "en* eth*";
            networkConfig.DHCP = "yes";
          };
        };

        # ── SSH ─────────────────────────────────────────────────────────────
        services = {
          openssh = {
            enable = true;
            openFirewall = true;
            settings = {
              PermitRootLogin = "yes"; # convenient for initial VPS provisioning
              PasswordAuthentication = lib.mkForce false;
            };
          };

          # ── QEMU guest integration ──────────────────────────────────────────
          # services.qemuGuest is already enabled by <my/virt/qemu>.
          # Add the SPICE guest agent so the hypervisor console works.
          spice-vdagentd.enable = true;
        };

        # ── Minimal package set ─────────────────────────────────────────────
        environment.systemPackages = with pkgs; [
          curl
          git
          htop
          parted
          rsync
          vim
        ];

        # Strip heavy docs to keep ISO size down.
        documentation = {
          man.enable = lib.mkForce false;
          doc.enable = lib.mkForce false;
          info.enable = lib.mkForce false;
          nixos.enable = lib.mkForce false;
        };

        # Resolve conflicting nix.gc.options definitions from den defaults.
        nix.gc.options = lib.mkForce "--delete-older-than 14d";

        # No desktop, no zram needed on a live VPS image.
        zramSwap.enable = lib.mkForce false;
      };
  };

  # ── Expose the ISO as a flake package ──────────────────────────────────────
  # self is captured from the top-level module argument above.
  # Build with: nix build .#vps-iso
  perSystem = {
    packages.vps-iso = self.nixosConfigurations.vps.config.system.build.isoImage;
  };
}
