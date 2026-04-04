{
  my.apps._.git.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.my.apps._.git;
    in
    {
      options.my.apps._.git = {
        lfs.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable Git LFS.";
        };

        userName = lib.mkOption {
          type = lib.types.str;
          description = "Git commit author name.";
        };

        userEmail = lib.mkOption {
          type = lib.types.str;
          description = "Git commit author email.";
        };

        signing = {
          format = lib.mkOption {
            type = lib.types.enum [
              "ssh"
              "gpg"
              "x509"
            ];
            default = "ssh";
            description = "Signature format.";
          };
          key = lib.mkOption {
            type = lib.types.str;
            default = "~/.ssh/NixOS.pub";
            description = "Path to the signing key.";
          };
          signByDefault = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Sign all commits by default.";
          };
        };

        allowedSignersFile = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.homeDirectory}/.ssh/allowed_signers";
          description = "Path to the SSH allowed signers file for commit verification.";
        };

        ignores = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            ".scratch"
            "*sync-conflict*"
          ];
          description = "Global gitignore patterns.";
        };

        extraSettings = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Extra entries merged into the git settings block.";
        };

        gpg = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable GPG agent.";
          };
          sshSupport = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable SSH support in the GPG agent.";
          };
        };

        lazygit = {
          enable = lib.mkEnableOption "LazyGit terminal UI for git";
          settings = lib.mkOption {
            type = lib.types.attrs;
            default = {
              gui.showIcons = true;
              gui.theme = {
                lightTheme = false;
                activeBorderColor = [
                  "green"
                  "bold"
                ];
                inactiveBorderColor = [ "grey" ];
                selectedLineBgColor = [ "blue" ];
              };
            };
            description = "Lazygit settings.";
          };
        };
      };

      config = {
        programs = {
          gpg.enable = cfg.gpg.enable;
          difftastic.enable = true;

          git = {
            enable = true;
            inherit (cfg) lfs ignores;
            signing = { inherit (cfg.signing) format key signByDefault; };
            settings = {
              user.name = cfg.userName;
              user.email = cfg.userEmail;
              init.defaultBranch = "main";
              pull.rebase = true;
              rerere.enable = true;
              column.ui = "auto";
              fetch.prune = true;
              interactive.singleKey = true;
              gpg.ssh.allowedSignersFile = cfg.allowedSignersFile;
            }
            // cfg.extraSettings;
          };

          lazygit = lib.mkIf cfg.lazygit.enable { inherit (cfg.lazygit) enable settings; };
        };

        services.gpg-agent = lib.mkIf cfg.gpg.enable {
          enable = true;
          enableSshSupport = cfg.gpg.sshSupport;
        };

        services.ssh-agent.enable = lib.mkIf (cfg.gpg.enable && cfg.gpg.sshSupport) (lib.mkForce false);

        home.packages = with pkgs; [ git-graph ];
      };
    };
}
