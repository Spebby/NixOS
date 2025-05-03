# /home-manager/modules/starship.nix

{ lib, ... }:

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
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "󱄅 (red)$username $directory ${
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
      }${prependDollarAndJoinWith " " versionControl}$line_break$character";

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

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
        style = "white";
        symbol = " ";
      };

      status = {
        format = "[$symbol](red)";
        symbol = "";
        success_symbol = " ";
        disabled = false;
      };

      git_status = {
        format = "[[(${
          prependDollarAndJoinWith "" [
            "conflicted"
            "untracked"
            "modified"
            "staged"
            "renamed"
            "deleted"
          ]
        })](218)($ahead_behind$stashed)]($style)";
        ahead = "[⇡${starshipVar "count"}](lavender) ";
        conflicted = "🏳";
        deleted = "󰗨 ${starshipVar "count"} ";
        diverged = "⇕⇡${starshipVar "ahead_count"}⇣${starshipVar "behind_count"} ";
        modified = "[ ${starshipVar "count"}]($style) ";
        staged = "[+$count](green) ";
        stashed = " ${starshipVar "count"} ";
        style = "red";
        untracked = "[ ${starshipVar "count"}]($style) ";
      };

      git_state = {
        format = "([$state( $progress_current/$progress_total)]($style))";
        style = "fg";
      };

      git_metrics = {
        disabled = false;
        format = "[+$added](green)|[-$deleted](red) ";
        only_nonzero_diffs = true;
      };
    };
  };
}
