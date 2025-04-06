# /hosts/rosso/configuration.nix

{
  pkgs,
  stateVersion,
  hostname,
  nixos-hardware,
  ...
}:

{
  networking.hostName = hostname;
  system.stateVersion = stateVersion;
  nixpkgs.config.cudaSupport = true;

  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../common.nix # Common to hosts
    ../../nixos/modules # Global modules
    nixos-hardware.nixosModules.lenovo-legion-16ach6h-hybrid
    ../../users/thom.nix
    ../../users/max.nix
  ];

  # TODO: move the theme specific stuff to machine specific configs.
  # I also like owl, Loader 2, Spinner Alt, Splash, Cuts Alt, DNA, Hexagon Dots Alt, Hexagons
  boot = {
    plymouth = {
      enable = true;
      theme = "cuts_alt";
      #extraConfig = "DeviceScale=1\n"; # Force Frame Buffer refresh b4 suspend
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
      ];
    };

    # Silent Boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"

      # === NVIDIA-Specific Fixes ===
      # Force s2idle (since S3 isn't supported)
      "mem_sleep_default=s2idle"
      # Disable PCIe power management quirks
      "pcie_aspm=off"
      "pcie_port_pm=off"
      # GPU memory preservation
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      # Workaround for resume failures
      "nvidia.NVreg_EnablePCIeGen3=1"

      # === Debugging (temporary) ===
      # Enable these if issues persist, then check `journalctl -b`:
      # "pm_debug_messages"
      # "nvidia.NVreg_EnableMSI=1"
    ];
    # Hide OS choice for bootloader
    # loader.timeout = 0;
  };

  environment = {
    systemPackages = [
      pkgs.home-manager
      pkgs.bottles
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  # Hyperland Specific
  programs.hyprland = {
    enable = true;

    # These two are sometimes nice but I don't want em' for now
    # withUWSM = true;
    # xwayland.enable = false;
  };

  security = {
    pam.services.hyprlock = { };
    #pki.certificateFiles = [
    #  ../../certs/eduroam.crt
    #];
  };

  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    sharedModules = [ { home.stateVersion = stateVersion; } ];
  };

  services.getty = {
    greetingLine = "moo";
    # autoLoginUser = user;
  };
}
