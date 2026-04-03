{ inputs, __findFile, ... }:
{
  den.hosts.x86_64-linux.rosso = {
    instantiate =
      args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);
  };

  den.aspects.rosso = {
    includes = [
      <my/boot/secure>
      <my/boot/graphical>
      <my/login/sddm>

      <my/profiles/laptop>
      <my/bluetooth>
      <my/gaming/max>
      <my/gaming/replays>

      <my/desktops/cosmic>
    ];

    nixos =
      { pkgs, lib, ... }:
      let
        winter-bg = pkgs.runCommand "winter-bg.mp4" { } ''
          cp ${../../../assets/backgrounds/winter-forest-snow-moewalls-com.mp4} $out
        '';
        winter-placeholder = pkgs.runCommand "winter-placeholder.png" { } ''
          cp ${../../../assets/backgrounds/winter-forest-placeholder.png} $out
        '';
      in
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

        environment.systemPackages = with pkgs; [
          dnsmasq
          phodav
        ];

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

        my.login.sddm = {
          enable = true;
          preset = "default";
          extraBackgrounds = [
            winter-bg
            winter-placeholder
          ];
          themeOverrides = {
            General = {
              scale = "1.5";
              enable-animations = true;
              background-fill-mode = "fill";
              animated-background-placeholder = "${winter-placeholder.name}";
            };
            LoginScreen = {
              background = "${winter-bg.name}";
              animated-background-placeholder = "${winter-placeholder.name}";
            };
            LockScreen = {
              background = "${winter-bg.name}";
              animated-background-placeholder = "${winter-placeholder.name}";
              blur = "1";
            };
            "LoginScreen.MenuArea.Session".position = "bottom-left";
          };
        };
      };
  };
}
