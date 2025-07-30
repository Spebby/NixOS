# /modules/productivity/obsidian.nix

{
  config,
  pkgs,
  lib,
  ...
}:
let
  gitSyncObsidian = pkgs.writeScriptBin "git-sync-obsidian" ''
        #!/bin/sh

        VAULT_DIR="$HOME/Media/Vaults/"
        cd $VAULT_DIR || exit 1

        git pull
    	git add .
        # Only commit if there are changes
        if ! git diff --quiet || ! git diff --cached --quiet; then
            git add .
            git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"
        fi
        git push
  '';

  cfg = config.obsidian;
  useGitSync = cfg.useGitSync.enable;
in
{
  options.obsidian = {
    enable = lib.mkEnableOption "Enable Obsidian";
    useGitSync.enable = lib.mkEnableOption "Enable vault git syncing for Obsidian?";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ] ++ lib.optional useGitSync gitSyncObsidian;

    # disable this iff useGitSync not enabled
    config = lib.mkIf useGitSync {
      systemd.user.services.git-sync-obsidian = {
        Unit = {
          Description = "Sync Obsidian Vault with GitHub";
          Wants = "git-sync-obsidian.timer";
        };
        Service = {
          ExecStart = "${gitSyncObsidian}/bin/git-sync-obsidian";
          Type = "oneshot";
          Environment = [ "SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh" ];
          # TODO: make this more flexible ^
        };
      };

      systemd.user.timers.git-sync-obsidian = {
        Unit.Description = "Run Git Sync for Obsidian Vault";
        Timer.OnCalendar = "*:0/15";
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
