# https://tangled.org/quasigod.xyz/nixconfig/blob/main/modules/virtualisation.nix

{ den, my, ... }:
{
  my.virt.provides = {
    qemu = den.lib.parametric {
      includes = [ (my.groups "kvm") ];
      nixos =
        { pkgs, ... }:
        {
          boot.kernelParams = [ "amd_iommu=on" ];
          programs.virt-manager.enable = true;
          environment.systemPackages = with pkgs; [
            gnome-boxes
            virglrenderer
          ];
          services.qemuGuest.enable = true;
          virtualisation = {
            libvirtd.enable = true;
            # Enable TPM emulation (for Windows 11)
            qemu.swtpm.enable = true;
            # Enable USB redirection
            spiceUSBRedirection.enable = true;
          };
        };
    };
    podman.nixos = {
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
