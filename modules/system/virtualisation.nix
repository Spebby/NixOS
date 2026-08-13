# https://tangled.org/quasigod.xyz/nixconfig/blob/main/modules/virtualisation.nix
{
  my.system._.virt.provides = {
    qemu = { my, ... }: {
      includes = [ my.batteries._.privileged-user ];
      nixos = { pkgs, ... }: {
        boot.kernelParams = [ "amd_iommu=on" ];
        users.privilegedGroups = [ "kvm" ];
        networking.firewall.trustedInterfaces = [ "virbr0" ];
        programs.virt-manager.enable = true;
        environment.systemPackages = with pkgs; [
          gnome-boxes
          virglrenderer
        ];

        services.qemuGuest.enable = true;
        virtualisation = {
          libvirtd = {
            enable = true;
            # Enable TPM emulation (for Windows 11)
            qemu.swtpm.enable = true;
          };
          # Enable USB redirection
          spiceUSBRedirection.enable = true;
        };
      };
    };

    waydroid.nixos.virtualisation.waydroid.enable = true;

    docker = { my, ... }: {
      includes = [ my.batteries._.privileged-user ];

      nixos = {
        virtualisation.docker.enable = true;
        users.privilegedGroups = [ "docker" ];
        networking.firewall.trustedInterfaces = [ "docker0" ];
      };
    };

    podman.nixos = {
      networking.firewall.trustedInterfaces = [ "podman0" ];
      virtualisation.podman = {
        enable = true;
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
      };
    };
  };
}
