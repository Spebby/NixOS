{ inputs, __findFile, ... }:
{
  den.hosts.x86_64-linux.tink = {
    instantiate =
      args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);
  };

  den.aspects.tink = {
    includes = [
      <my/boot/secure>
      <my/boot/graphical>
      <my/login/sddm>

      <my/profiles/desktop>
      <my/desktops/gnome>
    ];

    nixos =
      { pkgs, lib, ... }:
      let
        grass-bg = pkgs.runCommand "grass-bg.mp4" { } ''
          cp ${../../../assets/backgrounds/wavy-grass-moewalls-com.mp4} $out
        '';
        grass-placeholder = pkgs.runCommand "grass-placeholder.png" { } ''
          cp ${../../../assets/backgrounds/wavy-grass-placeholder.png} $out
        '';
      in
      {
        imports = [
          ./_hardware-configuration.nix
          ../_common
        ];

        boot = {
          plymouth = {
            theme = "cuts_alt";
            themePackages = with pkgs; [
              (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
            ];
            extraConfig = "DeviceScale=1";
          };
          kernelPackages = pkgs.linuxPackages_zen;
        };

        nix.gc = {
          dates = lib.mkForce "weekly";
          options = lib.mkForce "--delete-older-than 30d";
        };

        environment.systemPackages = with pkgs; [
          bottles
          libsForQt5.qt5.qtquickcontrols2
          libsForQt5.qt5.qtgraphicaleffects
        ];

        fonts = {
          enableDefaultPackages = true;
          packages = [ pkgs.jetbrains-mono ];
        };

        services = {
          auto-cpufreq.enable = false;
          tlp.enable = false;
          displayManager.defaultSession = "gnome";
        };

        my.login.sddm = {
          enable = true;
          preset = "rei";
          extraBackgrounds = [
            grass-bg
            grass-placeholder
          ];
          themeOverrides = {
            General = {
              scale = "1.0";
              enable-animations = true;
              background-fill-mode = "fill";
              animated-background-placeholder = "${grass-placeholder.name}";
            };
            LoginScreen = {
              background = "${grass-bg.name}";
              animated-background-placeholder = "${grass-placeholder.name}";
            };
            LockScreen = {
              background = "${grass-bg.name}";
              animated-background-placeholder = "${grass-placeholder.name}";
            };
            "LoginScreen.MenuArea.Session".position = "bottom-left";
          };
        };
      };
  };
}
