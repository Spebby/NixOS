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
      <my/services/plex>

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

        nix.settings.trusted-users = [
          "thom"
          "max"
        ];

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

          samba = {
            enable = true;
            securityType = "user";
            openFirewall = true;
            settings = {
              global = {
                "workgroup" = "WORKGROUP";
                "server string" = "smbnix";
                "netbios name" = "smbnix";
                "security" = "user";
                #"use sendfile" = "yes";
                #"max protocol" = "smb2";
                # note: localhost is the ipv6 localhost ::1
                "hosts allow" = "192.168.0. 127.0.0.1 localhost";
                "hosts deny" = "0.0.0.0/0";
                "guest account" = "nobody";
                "map to guest" = "bad user";
                "fruit:aapl" = "yes";
                "vfs objects" = "catia fruit streams_xattr";
              };
              "public" = {
                "path" = "/mnt/Shares/Public";
                "browseable" = "yes";
                "read only" = "no";
                "guest ok" = "yes";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "username";
                "force group" = "groupname";
              };
              "private" = {
                "path" = "/mnt/Shares/Private";
                "browseable" = "yes";
                "read only" = "no";
                "guest ok" = "no";
                "create mask" = "0644";
                "directory mask" = "0755";
                "force user" = "username";
                "force group" = "groupname";
              };
              "tm_share" = {
                "path" = "/mnt/Shares/tm_share";
                "valid users" = "username";
                "public" = "no";
                "writeable" = "yes";
                "force user" = "username";
                "fruit:time machine" = "yes";
              };
            };
          };
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
