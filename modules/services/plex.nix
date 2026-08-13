{ lib, ... }:
{
  my.services.provides.plex.nixos =
    { config, pkgs, ... }:
    let
      cfg = config.my.services.plex;
    in
    {
      options.my.services.plex = {
        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.plex;
          description = "Plex Media Server package to run.";
        };

        dataDir = lib.mkOption {
          type = lib.types.str;
          default = "/var/lib/plex";
          description = "Plex Media Server data directory.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "plex";
          description = "User account running Plex Media Server.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "plex";
          description = "Group for Plex Media Server process and files.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Open Plex service ports in the firewall.";
        };

        preventSuspendWhileStreaming = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Prevents automatic sleep while Plex is being streamed by a client";
        };
      };

      config = {
        users.users.plex = lib.mkIf (cfg.user == "plex") {
          isSystemUser = true;
          group = "plex";
          extraGroups = [ "users" ];
        };

        services.plex = {
          enable = true;
          inherit (cfg)
            package
            dataDir
            user
            group
            openFirewall
            ;
        };

        systemd.services.plex-suspend-inhibit = lib.mkIf cfg.preventSuspendWhileStreaming {
          description = "Prevent idle suspend while Plex is streaming";
          wantedBy = [ "multi-user.target" ];
          after = [ "plex.service" ];
          wants = [ "plex.service" ];

          serviceConfig = {
            Type = "simple";
            Restart = "always";
            RestartSec = 5;
          };

          script = ''
            exec ${pkgs.python3}/bin/python3 - <<'PY'
            import json
            import os
            import subprocess
            import time
            import urllib.request
            import xml.etree.ElementTree as ET

            PLEX_URL = "http://127.0.0.1:32400/status/sessions"
            PREFERENCES = "${cfg.dataDir}/Preferences.xml"

            inhibitor = None

            def get_token():
                try:
                    root = ET.parse(PREFERENCES).getroot()
                    return root.attrib.get("PlexOnlineToken")
                except Exception:
                    return None

            def streaming():
                token = get_token()
                if not token:
                    return False

                request = urllib.request.Request(
                    PLEX_URL,
                    headers={
                        "Accept": "application/json",
                        "X-Plex-Token": token,
                    },
                )

                try:
                    with urllib.request.urlopen(request, timeout=5) as response:
                        data = json.load(response)

                    for session in data.get("MediaContainer", {}).get("Metadata", []):
                        player = session.get("Player", {})
                        if player.get("state") == "playing":
                            return True

                except Exception:
                    pass

                return False

            def start_inhibitor():
                global inhibitor

                if inhibitor is None:
                    inhibitor = subprocess.Popen([
                        "${pkgs.systemd}/bin/systemd-inhibit",
                        "--what=idle",
                        "--mode=block",
                        "--who=Plex",
                        "--why=Media is currently playing",
                        "${pkgs.coreutils}/bin/sleep",
                        "infinity",
                    ])

            def stop_inhibitor():
                global inhibitor

                if inhibitor is not None:
                    inhibitor.terminate()
                    try:
                        inhibitor.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        inhibitor.kill()

                    inhibitor = None

            while True:
                if streaming():
                    start_inhibitor()
                else:
                    stop_inhibitor()

                time.sleep(10)
            PY
          '';
        };
      };
    };
}
