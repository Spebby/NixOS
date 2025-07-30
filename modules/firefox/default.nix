# /home-manager/modules/firefox.nix

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.firefox;
in
{
  options.firefox.enable = lib.mkEnableOption "Enable custom Firefox configuration";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      languagePacks = [
        "de"
        "en-GB"
        "nl"
      ];

      nativeMessagingHosts = [ ];

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;

        # I do actually like these for when I have to use windows
        DisableFirefoxAccounts = false;
        DisableAccounts = false;

        DisableSetDesktopBackground = true;
        DontCheckDefaultBrowser = true;
        DisableFirefoxScreenshots = true;

        # --- Extensions ---
        ExtensionSettings = {
          #"*".installation_mode = "blocked";

          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };

          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };

          # Language Tool
          "languagetool-webextension@languagetool.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Chameleon
          "{3579f63b-d8ee-424f-bbb6-6d0ce3285e6a}" = {
            install_url = "chameleon-ext";
            installation_mode = "force_installed";

          };

          # GMail Checker
          "checkerplusforgmail@jasonsavard.com" = {
            install_url = "checker-plus-gmail";
            installation_mode = "normal_installed";
          };

          # Clear URLs
          "{74145f27-f039-47ce-a470-a662b129930a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            installation_mode = "force_installed";
          };

          # Dark Reader
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Imagus
          "{00000f2a-7cde-4f20-83ed-434fcb420d71}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/imagus/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Indie Wiki Buddy
          "{cb31ec5d-c49a-4e5a-b240-16c767444f62}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/indie-wiki-buddy/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Pinned Proton Mail
          "{1f6ea0dc-66f1-4442-9799-5c5b4783c1a4}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/pinned-protonmail/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Shinigami Eyes
          "shinigamieyes@shinigamieyes" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/shinigami-eyes/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Tabliss
          "extension@tabliss.io" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tabliss/latest.xpi";
            installation_mode = "force_installed";
          };

          # Return YouTube Dislikes
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Sponsor Block
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "normal_installed";
          };
          # Shadertoy Unofficial Plugin
          "{cab6fe0d-6896-4cb6-a40c-1613dd3ed8f9}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/shadertoy-unofficial-plugin/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Tree Style Tabs
          "treestyletab@piro.sakura.ne.jp" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/treestyletab@piro.sakura.ne.jp/latest.xpi";
            installation_mode = "normal_installed";
          };

          # --- Themes ---

          # Gruvbox Dark Theme
          "{eb8c4a94-e603-49ef-8e81-73d3c4cc04ff}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/gruvbox-dark-theme/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Gruvbox Dark Theme 2
          "{21ab01a8-2464-4824-bccb-6db15659347e}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/gruvbox-material-soft-theme/latest/xpi";
            installation_mode = "normal_installed";
          };

          "firefox-alpenglow@mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefox-alpenglow/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        preference = {
          # XDG
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "widget.use-xdg-desktop-portal.location" = 2;
          "widget.use-xdg-desktop-portal.mime-handler" = 2;
          "widget.use-xdg-desktop-portal.native-messaging" = 0;
          "widget.use-xdg-desktop-portal.open-uri" = 2;
          "widget.use-xdg-desktop-portal.settings" = 2;
        };
      };

      profiles = {
        user = {
          search = {
            default = "ddg";
            privateDefault = "ddg";
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
            };
          };
        };
      };
    };
  };
}
