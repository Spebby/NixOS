{
  my,
  inputs,
  den,
  ...
}:
{
  my.gaming.provides = {
    min = {
      nixos =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        let
          cfg = config.my.gaming.min;
        in
        {
          options.my.gaming.min = {
            steam = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable Steam.";
              };
              extraCompatPackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                default = with pkgs; [
                  proton-ge-bin
                  steamtinkerlaunch
                ];
                description = "Extra Proton/compat packages added to Steam.";
              };
            };

            gamescope = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable gamescope session compositor.";
              };
              args = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [
                  "-f"
                  "--adaptive-sync"
                  "--mangoapp"
                ];
                description = "Arguments passed to gamescope.";
              };
              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  Additional raw gamescope arguments appended after <option>args</option>.
                  Useful for flags not exposed by the NixOS module (e.g. "--hdr-enabled",
                  "--prefer-vk-device", "--force-windows-fullscreen").
                '';
                example = [
                  "--hdr-enabled"
                  "--prefer-vk-device 1002:687f"
                ];
              };
            };

            ntsync = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Load the ntsync kernel module (low-overhead NT sync primitive for Wine/Proton).";
            };

            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Extra packages to add on top of the default min set.";
              example = lib.literalExpression "[ pkgs.bottles ]";
            };
          };

          config = {
            boot.kernelModules = lib.mkIf cfg.ntsync [ "ntsync" ];

            environment.systemPackages =
              with pkgs;
              [
                cartridges
                heroic
                lutris
                umu-launcher
              ]
              ++ cfg.extraPackages;

            hardware.graphics.enable32Bit = true;

            programs = {
              steam = lib.mkIf cfg.steam.enable {
                enable = true;
                inherit (cfg.steam) extraCompatPackages;
              };
              gamescope = lib.mkIf cfg.gamescope.enable {
                enable = true;
                args = cfg.gamescope.args ++ cfg.gamescope.extraArgs;
              };
            };
          };
        };
    };

    max = den.lib.parametric {
      includes = [
        my.gaming._.replays
        my.gaming._.min
        my.gaming._.mcsr
      ];
      nixos =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        let
          cfg = config.my.gaming.max;
        in
        {
          options.my.gaming.max = {
            input-remapper = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable input-remapper service.";
              };
              # Allow passing extra config to the upstream input-remapper module
              # if/when it grows options (currently just enable).
              extraConfig = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = ''
                  Attribute set merged into <option>services.input-remapper</option>.
                  Use for upstream options not explicitly wrapped here.
                '';
                example = lib.literalExpression "{ verbosity = 2; }";
              };
            };

            lowLatency = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable PipeWire low-latency profile.";
              };
              quantum = lib.mkOption {
                type = lib.types.int;
                default = 512;
                description = "PipeWire quantum for low-latency mode.";
              };
              rate = lib.mkOption {
                type = lib.types.int;
                default = 48000;
                description = "PipeWire sample rate paired with low-latency quantum.";
              };
            };

            tablet = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable OpenTabletDriver for drawing/gaming tablets.";
              };
            };

            steam = {
              usePlatformOptimisations = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              openRemotePlayFirewall = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
              openLocalNetworkGameTransfersFirewall = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
            };

            overlay = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Install MangoHud + GOverlay overlay tooling.";
              };
            };

            frameGeneration = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Install lsfg-vk (Lossless Scaling frame generation for Vulkan).";
              };
            };

            saves = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Install Ludusavi for cross-platform game save management.";
              };
            };

            extraPackages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "Extra packages added on top of the default max set.";
            };
          };

          config = {
            imports = [
              inputs.nix-gaming.nixosModules.platformOptimizations
              inputs.nix-gaming.nixosModules.pipewireLowLatency
            ];

            hardware.opentabletdriver.enable = lib.mkIf cfg.tablet.enable true;

            services = {
              input-remapper = lib.mkIf cfg.input-remapper.enable (
                { enable = true; } // cfg.input-remapper.extraConfig
              );
              pipewire.lowLatency = lib.mkIf cfg.lowLatency.enable {
                inherit (cfg.lowLatency) enable quantum rate;
              };
            };

            programs.steam = {
              platformOptimizations.enable = cfg.steam.usePlatformOptimisations;
              remotePlay.openFirewall = cfg.steam.openRemotePlayFirewall;
              localNetworkGameTransfers.openFirewall = cfg.steam.openLocalNetworkGameTransfersFirewall;
            };

            environment.systemPackages =
              with pkgs;
              [
                protonplus
                protontricks
                winetricks
                gpu-screen-recorder-gtk
              ]
              ++ lib.optionals cfg.overlay.enable [
                mangohud
                goverlay
              ]
              ++ lib.optionals cfg.frameGeneration.enable [
                lsfg-vk
                lsfg-vk-ui
              ]
              ++ lib.optionals cfg.saves.enable [ ludusavi ]
              ++ cfg.extraPackages;
          };
        };
    };

    replays.homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.my.gaming.replays;
      in
      {
        options.my.gaming.replays = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the gpu-screen-recorder replay background service.";
          };

          fps = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Recording framerate.";
          };

          replayDuration = lib.mkOption {
            type = lib.types.int;
            default = 60;
            description = "Replay buffer length in seconds.";
          };

          codec = lib.mkOption {
            type = lib.types.enum [
              "av1"
              "h264"
              "hevc"
              "vp8"
              "vp9"
            ];
            default = "av1";
            description = "Video codec for captured replays.";
          };

          quality = lib.mkOption {
            type = lib.types.enum [
              "very_high"
              "high"
              "medium"
              "low"
            ];
            default = "high";
            description = "Encoding quality preset.";
          };

          container = lib.mkOption {
            type = lib.types.enum [
              "mp4"
              "mkv"
              "webm"
            ];
            default = "mkv";
            description = "Container format for replay files.";
          };

          outputDir = lib.mkOption {
            type = lib.types.str;
            default = "%h/Videos/Replays";
            description = "Directory to write replay files into. Supports systemd specifiers (e.g. %h for $HOME).";
          };

          audioOutputs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "default_output"
              "default_input"
            ];
            description = "PipeWire/PulseAudio sink/source names to capture.";
            example = [
              "alsa_output.pci-0000_00_1f.3.analog-stereo"
              "default_input"
            ];
          };

          restorePortalSession = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Pass -restore-portal-session to reuse the last xdg-desktop-portal window selection.";
          };

          verbose = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable verbose logging from gpu-screen-recorder.";
          };

          extraArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Raw extra arguments appended to the gpu-screen-recorder command line.
              Refer to `gpu-screen-recorder --help` for the full flag reference.
            '';
            example = [
              "-cursor yes"
              "-scale 1920x1080"
            ];
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.gpu-screen-recorder ];

          systemd.user.services.gpu-screen-recorder =
            let
              audioFlags = lib.concatMapStringsSep " " (a: "-a '${a}'") cfg.audioOutputs;
              extraFlags = lib.concatStringsSep " " cfg.extraArgs;
            in
            {
              Unit.Description = "gpu-screen-recorder replay service";
              Install.WantedBy = [ "graphical-session.target" ];
              Service.ExecStart = lib.concatStringsSep " " (
                lib.filter (s: s != "") [
                  "${lib.getExe pkgs.gpu-screen-recorder}"
                  "-w portal"
                  "-f ${toString cfg.fps}"
                  "-r ${toString cfg.replayDuration}"
                  "-k ${cfg.codec}"
                  audioFlags
                  "-c ${cfg.container}"
                  "-q ${cfg.quality}"
                  "-o ${cfg.outputDir}"
                  (lib.optionalString cfg.restorePortalSession "-restore-portal-session yes")
                  "-v ${if cfg.verbose then "yes" else "no"}"
                  extraFlags
                ]
              );
            };
        };
      };
  };
}
