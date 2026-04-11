{ my, ... }:
{
  my.performance = {
    nixos =
      { lib, config, ... }:
      let
        cfg = config.my.performance;

        myOptions = {
          hugepages = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable transparent hugepages and related sysctl tuning.";
            };
            mode = lib.mkOption {
              type = lib.types.enum [
                "always"
                "madvise"
                "never"
              ];
              default = "always";
              description = "Transparent hugepage mode.";
            };
            size = lib.mkOption {
              type = lib.types.enum [
                "2M"
                "1G"
              ];
              default = "1G";
              description = "Default hugepage size.";
            };
          };
          ipcsShm = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable IPCS shared memory (ipcs_shm).";
          };
          compactMemory = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable kernel memory compaction (vm.compact_memory). Disable to reduce latency spikes.";
          };
          extraSysctl = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.oneOf [
                lib.types.str
                lib.types.int
              ]
            );
            default = { };
            description = "Extra sysctl settings merged on top of the performance defaults.";
          };
        };
      in
      {
        options.my.performance = myOptions;

        config.boot.kernel.sysctl = lib.mkIf cfg.hugepages.enable (
          {
            "transparent_hugepage" = cfg.hugepages.mode;
            "vm.nr_hugepages_defrag" = 0;
            "default_hugepagez" = cfg.hugepages.size;
            "hugepagesz" = cfg.hugepages.size;
          }
          // lib.optionalAttrs cfg.ipcsShm { "ipcs_shm" = 1; }
          // lib.optionalAttrs (!cfg.compactMemory) { "vm.compact_memory" = 0; }
          // cfg.extraSysctl
        );
      };

    provides = {
      responsive = {
        includes = [ my.performance ];
        nixos =
          { lib, config, ... }:
          let
            cfg = config.my.performance.responsive;
          in
          {
            options.my.performance.responsive = {
              swappiness = lib.mkOption {
                type = lib.types.ints.between 0 200;
                default = 1;
                description = "vm.swappiness value. 1 avoids swap unless critical.";
              };
              watchdog = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable kernel watchdog. Disable to reduce latency.";
              };
              auditd = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable kernel auditing. Disable to reduce overhead.";
              };
              fullPreempt = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Use full preemption (preempt=full) for lower latency.";
              };
              nohzFull = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable full dynticks on all CPUs (nohz_full=all).";
              };
              threadIrqs = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Thread interrupt handlers (threadirqs) for more predictable scheduling.";
              };
              extraKernelParams = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Extra kernel params appended to the responsive set.";
              };
            };

            config.boot = {
              kernel.sysctl."vm.swappiness" = cfg.swappiness;
              kernelParams =
                lib.optionals (!cfg.watchdog) [
                  "nowatchdog"
                  "nosoftlockup"
                ]
                ++ lib.optionals (!cfg.auditd) [ "audit=0" ]
                ++ lib.optionals cfg.fullPreempt [ "preempt=full" ]
                ++ lib.optionals cfg.nohzFull [
                  "nohz_full=all"
                  "skew_tick=1"
                ]
                ++ lib.optionals cfg.threadIrqs [ "threadirqs" ]
                ++ cfg.extraKernelParams;
            };
          };
      };

      max = {
        includes = [ my.performance._.responsive ];
        nixos =
          { lib, config, ... }:
          let
            cfg = config.my.performance.max;
          in
          {
            options.my.performance.max = {
              cpuGovernor = lib.mkOption {
                type = lib.types.enum [
                  "performance"
                  "schedutil"
                  "powersave"
                ];
                default = "performance";
                description = "CPU frequency scaling governor.";
              };
              usbAutosuspend = lib.mkOption {
                type = lib.types.int;
                default = 60;
                description = "USB autosuspend delay in seconds. Set to -1 to disable.";
              };
              powerEfficientWorkqueue = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Enable power-efficient workqueue scheduling. Disable for max throughput.";
              };
              extraKernelParams = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Extra kernel params appended to the max set.";
              };
            };

            config.boot.kernelParams = [
              "cpufreq.default_governor=${cfg.cpuGovernor}"
              "usbcore.autosuspend=${toString cfg.usbAutosuspend}"
              "workqueue.power_efficient=${if cfg.powerEfficientWorkqueue then "true" else "false"}"
            ]
            ++ cfg.extraKernelParams;
          };
      };
    };
  };
}
