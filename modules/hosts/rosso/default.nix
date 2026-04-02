{ inputs, ... }:
{
  den.hosts.x86_64-linux.rosso = {
    instantiate =
      args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);
  };

  den.aspects.rosso = {
    includes = [
      <my/profiles/laptop>
      <my/profiles/modern>
      <my/gaming/max>
      <my/gaming/replays>

      <my/desktops/cosmic>
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          ./_drivers.nix
          ./_hardware-configuration.nix
          ../_common/locale.nix
        ];

        boot = {
          loader.grub = {
            theme = "${import ./_grubtheme.nix { inherit pkgs; }}";
            configurationLimit = 3;
          };
          plymouth = {
            theme = "cuts_alt";
            themePackages = with pkgs; [
              (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
            ];
            extraConfig = "DeviceScale=1.5";
          };
        };

        boot.kernelParams = [ "resume=/.swapfile" ];
        boot.kernelPackages = pkgs.linuxPackages_zen;

        nix.gc = {
          dates = "daily";
          options = "--delete-older-than 7d";
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
