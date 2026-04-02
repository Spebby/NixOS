{ inputs, __findFile, ... }:
{
  den.hosts.x86_64-linux.rosso = {
    instantiate =
      args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);
  };

  den.aspects.rosso = {
    includes = [
      <my/boot/secure>
      <my/profiles/laptop>
      <my/profiles/modern>
      <my/gaming/max>
      <my/gaming/replays>

      <my/desktops/cosmic>
    ];

    nixos =
      { pkgs, lib, ... }:
      {
        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
          inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
          inputs.nixos-hardware.nixosModules.common-gpu-amd
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          ./_drivers.nix
          ./_hardware-configuration.nix
          ../_common
        ];

        #my.boot.grub = {
        #   enable = true;
        #   devices = [ "nodev" ];
        #   efiSupport = true;
        #   useOSProber = true;
        #   configurationLimit = 3;
        #   theme = rossoGrubTheme;
        #};

        boot = {
          plymouth = {
            theme = "cuts_alt";
            themePackages = with pkgs; [
              (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
            ];
            extraConfig = "DeviceScale=1.5";
          };

          kernelParams = [ "resume=/.swapfile" ];
          kernelPackages = pkgs.linuxPackages_zen;
        };

        nix.gc = {
          dates = lib.mkForce "daily";
          options = lib.mkForce "--delete-older-than 7d";
        };

        fonts = {
          enableDefaultPackages = true;
          packages = [ pkgs.jetbrains-mono ];
        };

        services = {
          auto-cpufreq.enable = false;
          displayManager = {
            defaultSession = "cosmic";
          };
        };
      };
  };
}
