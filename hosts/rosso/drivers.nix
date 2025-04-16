# /hosts/rosso/drivers.nix

# nixos-hardware is a great resource, but I'm not getting good results from their setups.
# I want a little more control, especially over TLP.

{
  config,
  pkgs,
  lib,
  nixos-hardware,
  ...
}:

{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-cpu-amd-zenpower
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  options = {
    nvidia.enable = lib.mkEnableOption "enables proprietary drivers for NVIDIA GPUs";
    # TL;DR, Gnome has power management settings that don't mix w/ TLP
  };

  config = lib.mkIf config.nvidia.enable {
    nixpkgs.config = {
      cudaSupport = true;
      # Only add this if you’re running Nix on something exotic or experimental:
      allowUnsupportedSystem = true;
    };
    environment.variables = {
      CUDA_CACHE_PATH = "\${XDG_CACHE_HOME}/nv";
      BACKLIGHT_DEVICE = "amdgpu_bl1";
    };

    environment.systemPackages = with pkgs; [
      nvidia-vaapi-driver
      egl-wayland
      corectrl
      nvtopPackages.full
    ];

    # For the moment, I only want to use Offload. However, at some point it may be worth making specialisations for Clamshell & other modes.
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      # If I have issues, uncomment this. For the moment, since we boot w/ iGPU,
      # This will let Plymouth work at boot.
      amdgpu.initrd.enable = true;
      graphics = {
        enable = true;
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # Use Open Source (not nouveau) kernel modules? Turning+
        open = false;

        # Required
        # nvidia-drm.modeset=1 is required for some wayland compositors
        modesetting.enable = true;

        # NVIDIA X Server Settings
        nvidiaSettings = false;

        # Fine Grained Power Management for use w/ offload. Turning+
        powerManagement = {
          enable = true;
          finegrained = false;
        };
        dynamicBoost.enable = true;

        prime = {
          # Offload Mode puts dGPU to sleep, until it is told to wake up. Applications must be explicitly "offloaded" to the dGPU for this to happen. This mode is very battery efficient.
          # Offload CMD mode enables the wrapper script, `nvidia-offload`, which sets certain env variables to offload an application.
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          # Sync Mode delegates rendering to dGPU entirely... dGPU does *not go to sleep* when sync is enabled.
          # In Reverse Sync Mode, the iGPU is bypassed entirely, and the dGPU becomes the primairy output device. May be desirable for Clamshell mode.
          sync.enable = false;
          reverseSync.enable = false;

          amdgpuBusId = "PCI:35:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };

        # Set True for potential screen-tearing fix
        forceFullCompositionPipeline = false;
      };
    };

    boot = {
      # Investigate if any of these are needed
      kernelParams = [
        # === NVIDIA-Specific Fixes ===
        # Force s2idle (since S3 isn't supported)
        #"mem_sleep_default=s2idle"

        # Disable PCIe power management quirks
        #"pcie_aspm=off"
        #"pcie_port_pm=off"
        # GPU memory preservation
        #"nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        # Workaround for resume failures
        #"nvidia.NVreg_EnablePCIeGen3=1"

        # === Debugging (temporary) ===
        # Enable these if issues persist, then check `journalctl -b`:
        # "pm_debug_messages"
        # "nvidia.NVreg_EnableMSI=1"
      ];

      # This is mainly an X11 support thing. Investigate if we need it.
      blacklistedKernelModules = [ "nouveau" ];

      # This probably won't work properly.
      # I was right this shit didn't work.
      initrd.kernelModules = [
        #"nvidia"
        #"nvidia_modeset"
        #"nvidia_uvm"
        #"nvidia_drm"
      ];
      kernelModules = [
        "amdgpu"
        "kvm-amd"
      ];
    };
  };
}
