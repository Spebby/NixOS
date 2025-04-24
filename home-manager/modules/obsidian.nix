{ pkgs, ... }:
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
in
{
  home.packages = [
    pkgs.obsidian
    gitSyncObsidian
  ];

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
}
