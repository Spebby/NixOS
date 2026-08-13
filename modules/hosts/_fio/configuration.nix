{ inputs, __findFile, ... }: {
  den.hosts.x86_64-linux.fio = {
    users = {
      thom = { };
    };
    instantiate =
      args: inputs.nixpkgs-patcher.lib.nixosSystem ({ nixpkgsPatcher.inputs = inputs; } // args);

    displays = {
      DP-1 = {
        wallpaper = ../../../assets/backgrounds/winter-forest-placeholder.png;
      };
    };
  };

  den.aspects.fio = {
    includes = [
      <my/boot/secure>
      <my/boot/graphical>
      <my/login/sddm>
      <my/system/filesystems/zfs>

      <my/profiles/desktop>
      <my/bluetooth>
      <my/gaming/max>
      <my/gaming/replays>
      <my/graphics>

      <my/services/plex>
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
          ./_hardware-configuration.nix
          ../_common
        ];

        nix.settings.trusted-users = [ "thom" ];
        nixpkgs.config.cudaSupport = true;
        boot = {
          plymouth = {
            theme = "cuts_alt";
            themePackages = with pkgs; [
              (adi1090x-plymouth-themes.override { selected_themes = [ "cuts_alt" ]; })
            ];
            extraConfig = "DeviceScale=1.5";
          };

          #kernelParams = [ "resume=/.swapfile" ];
          kernelPackages = pkgs.linuxPackages_zen;
        };

        nix.gc = {
          dates = lib.mkForce "weekly";
          options = lib.mkForce "--delete-older-than 7d";
        };

        fonts = {
          enableDefaultPackages = true;
          packages = [ pkgs.jetbrains-mono ];
        };

        networking.hostId = "4e98920d";
        services = {
          auto-cpufreq.enable = false;
          tlp.enable = false;
          displayManager.defaultSession = "cosmic";

          samba = {
            enable = true;
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
            };
            "LoginScreen.MenuArea.Session".position = "bottom-left";
          };
        };
      };
  };
}
