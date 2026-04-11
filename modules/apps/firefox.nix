{
  my.apps._.firefox.homeManager =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.my.apps._.firefox;
      ext = cfg.extensions;
    in
    {
      options.my.apps._.firefox = {
        languagePacks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "de"
            "en-GB"
            "nl"
          ];
          description = "Firefox language packs to install.";
        };
        extensions = {
          ublock = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install uBlock Origin policy.";
          };
          darkReader = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install Dark Reader policy.";
          };
          sponsorBlock = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Install SponsorBlock policy.";
          };
        };
      };

      config = {
        programs.firefox = {
          enable = true;
          inherit (cfg) languagePacks;
          profiles.user = {
            search = {
              force = true;
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
                "Home Manager Options" = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com/";
                      params = [
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                        {
                          name = "release";
                          value = "master";
                        }
                      ];
                    }
                  ];

                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                  definedAliases = [ "@ho" ];
                };
              };
            };
          };

          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DontCheckDefaultBrowser = true;
            DisableFirefoxScreenshots = true;
            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
            Preferences = {
              "widget.use-xdg-desktop-portal.file-picker" = {
                Value = 1;
                Status = "locked";
              };
              "widget.use-xdg-desktop-portal.open-uri" = {
                Value = 2;
                Status = "locked";
              };
            };

            ExtensionSettings = {
              # Privacy Badger:
              "jid1-MnnxcxisBPnSXQ@jetpack" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
                installation_mode = "normal_installed";
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
            }
            // lib.optionalAttrs ext.ublock {
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };
            }
            // lib.optionalAttrs ext.darkReader {
              "addon@darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "normal_installed";
              };
            }
            // lib.optionalAttrs ext.sponsorBlock {
              "sponsorBlocker@ajay.app" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          };
        };
      };
    };
}
