let
  prependDollarAndJoinWith =
    separator: strings: builtins.concatStringsSep separator (map (s: "$" + s) strings);
  starshipVar = s: "\$\{${s}\}";

  versionControl = [
    "vcsh"
    "pijul_channel"
    "hg_branch"
    "git_state"
    "git_branch"
    "git_commit"
    "git_metrics"
    "git_status"
  ];

  buildTooling = [
    "cmake"
    "gradle"
    "meson"
  ];

  environment = [
    "guix_shell"
    "nix_shell"
    "direnv"
    "env_var"
  ];

  languages = [
    "c"
    "cobol"
    "elixir"
    "elm"
    "erlang"
    "fennel"
    "gleam"
    "golang"
    "haskell"
    "haxe"
    "java"
    "julia"
    "kotlin"
    "lua"
    "nim"
    "nodejs"
    "ocaml"
    "opa"
    "perl"
    "php"
    "purescript"
    "python"
    "raku"
    "rlang"
    "red"
    "ruby"
    "rust"
    "scala"
    "solidity"
    "swift"
    "typst"
    "vlang"
    "zig"
    "crystal"

    "deno"
    "dotnet"
  ];

  containerization = [
    "container"
    "singularity"
    "kubernetes"
    "docker_context"
    "vagrant"
  ];
in
{ inputs, ... }:
{
  my.apps._.shell.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.shell;
    in
    {
      options.my.apps._.shell = {
        zsh = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable ZSH shell config.";
          };
          enableCompletion = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable ZSH completion.";
          };
          extraAliases = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Additional shell aliases to merge with the defaults.";
          };
          extraInitContent = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Extra content appended to zsh initContent.";
          };
        };

        starship = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Starship shell prompt.";
          };
          enableZshIntegration = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable Zsh integration with Starship.";
          };
        };
      };

      config = {
        services.cliphist.enable = true;
        fonts.fontconfig.enable = true;

        programs.zsh = lib.mkIf cfg.zsh.enable {
          inherit (cfg.zsh) enable enableCompletion;
          dotDir = config.home.homeDirectory;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          shellAliases = {
            #nix-sw = "nh os switch";
            #nix-upd = "nh os switch --update";
            #nix-hms = "nh home switch";
            #pkgs = "nvim ${flakeDir}/nixos/packages.nix";

            microfetch = "microfetch && echo";
            ".." = "cd ..";
            vim = lib.getExe inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
            ls = "eza --group-directories-first --icons";
            cat = "bat";
            grep = "rg";
            grepchild = "grep -rnwe";
            firefox = "exec firefox";
            xev = "wev";
          }
          // cfg.zsh.extraAliases;

          history.size = 10000;
          history.path = "${config.xdg.dataHome}/zsh/history";

          # it may be worth eventually translating over the vicmd and zle-keymap stuff in the old config
          initContent = "" + cfg.zsh.extraInitContent;
        };

        programs.starship = lib.mkIf cfg.starship.enable {
          # ... (starship settings block unchanged from your original)
          inherit (cfg.starship) enable enableZshIntegration;
          settings = {
            format = " 󱄅 (red)$username$hostname $directory ${
               lib.concatMapStringsSep "" (prependDollarAndJoinWith "") [
                 languages
                 buildTooling
                 environment
                 containerization
                 [
                   "cmd_duration"
                   "fill"
                 ]
               ]
             }${prependDollarAndJoinWith "" versionControl}$line_break$character";

            add_newline = true;
            fill.symbol = " ";

            hostname = {
              ssh_only = false;
              format = "[$ssh_symbol$hostname]($style) ";
              style = "bold purple";
            };
            character = {
              success_symbol = "[ & ](bold green)";
              error_symbol = "[ & ](bold red)";
              vicmd_symbol = "[ & ](fg)";
            };
            username = {
              show_always = true;
              format = "[$user]($style)@";
            };
            directory = {
              format = "at [$path]($style)[$read_only]($read_only_style)";
              truncation_length = 10;
              truncation_symbol = "../";
              home_symbol = "~";
              read_only = "  ";
              read_only_style = "red";
            };

            nix_shell = {
              format = "via [$state($name)]($style) ";
              impure_msg = "󰼩 ";
              pure_msg = "󱩰 ";
            };

            custom.fhs_shell = {
              when = "test \"$FHS\" = 1";
              format = "[FHS](bold yellow) ";
              description = "Show FHS mode indicator when FHS=1 is set";
              shell = [
                "bash"
                "sh"
                "zsh"
              ];
            };

            status = {
              format = "[$symbol](red)";
              symbol = "";
              success_symbol = " ";
              disabled = false;
            };

            git_branch = {
              format = " [$symbol$branch(:$remote_branch)]($style)";
              style = "white";
              symbol = " ";
            };

            git_status = {
              format = "( [${
                prependDollarAndJoinWith "" [
                  "conflicted"
                  "untracked"
                  "modified"
                  "staged"
                  "renamed"
                  "deleted"
                ]
              }](218) [$ahead_behind$stashed]($style))";
              style = "red";
              ahead = "[⇡${starshipVar "count"}](lavender)";
              conflicted = " ";
              deleted = "󰗨 ${starshipVar "count"}";
              diverged = "⇕⇡${starshipVar "ahead_count"}⇣${starshipVar "behind_count"}";
              modified = "[ ${starshipVar "count"}]($style)";
              staged = "[+$count](green)";
              stashed = " ${starshipVar "count"}";
              untracked = "[ ${starshipVar "count"}]($style)";
            };

            git_state = {
              format = "\\([$state( $progress_current/$progress_total)]($style)\\)";
              style = "bold yellow";
              bisect = "BISECTING";
            };

            git_commit = {
              format = " [\\($hash$tag\\)]($style)";
            };

            git_metrics = {
              disabled = false;
              format = " [+$added](green)|[-$deleted](red)";
              only_nonzero_diffs = true;
            };
          };
        };
      };
    };
}
