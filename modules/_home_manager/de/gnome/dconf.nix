# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ config, lib, ... }:

with lib.hm.gvariant;
{
  dconf.settings = lib.mkIf config.gnome.enable {
    "TextEditor" = {
      style-scheme = "stylix";
    };

    "Totem" = {
      active-plugins = [
        "vimeo"
        "screenshot"
        "autoload-subtitles"
        "mpris"
        "rotation"
        "recent"
        "variable-rate"
        "skipto"
        "save-file"
        "screensaver"
        "open-directory"
        "apple-trailers"
        "movie-properties"
      ];
      subtitle-encoding = "UTF-8";
    };

    "baobab/ui" = {
      is-maximized = false;
      window-size = mkTuple [
        960
        600
      ];
    };

    "calendar" = {
      active-view = "month";
      window-maximized = true;
      window-size = mkTuple [
        768
        600
      ];
    };

    "clocks" = {
      timers = "[{'duration': <240>, 'name': <''>}]";
    };

    "clocks/state/window" = {
      maximized = false;
      panel-id = "world";
      size = mkTuple [
        870
        690
      ];
    };

    "control-center" = {
      last-panel = "system";
      window-state = mkTuple [
        1704
        1033
        false
      ];
    };

    "desktop/app-folders" = {
      folder-children = [
        "Utilities"
        "YaST"
      ];
    };

    "desktop/app-folders/folders/Utilities" = {
      apps = [
        "gnome-abrt.desktop"
        "gnome-system-log.desktop"
        "nm-connection-editor.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.DejaDup.desktop"
        "org.gnome.Dictionary.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.eog.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.fonts.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.tweaks.desktop"
        "org.gnome.Usage.desktop"
        "vinagre.desktop"
      ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "desktop/break-reminders" = {
      selected-breaks = [ "movement" ];
    };

    "desktop/break-reminders/eyesight" = {
      play-sound = true;
    };

    "desktop/break-reminders/movement" = {
      duration-seconds = mkUint32 300;
      interval-seconds = mkUint32 1800;
      play-sound = true;
    };

    "desktop/calendar" = {
      show-weekdate = false;
    };

    "desktop/input-sources" = {
      mru-sources = [
        (mkTuple [
          "xkb"
          "pt"
        ])
        (mkTuple [
          "xkb"
          "br"
        ])
        (mkTuple [
          "xkb"
          "us"
        ])
      ];
      show-all-sources = false;
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
      ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "DMZ-Black";
      document-font-name = "Noto Serif  10";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Noto Sans 11";
      gtk-theme = "adw-gtk3";
      icon-theme = "Papirus-Dark";
      monospace-font-name = "JetBrains Mono 11";
      show-battery-percentage = true;
    };

    "desktop/notifications" = {
      application-children = [
        "org-gnome-nautilus"
        "org-gnome-console"
        "firefox"
        "com-google-androidstudio"
        "discord"
        "gnome-power-panel"
        "code"
        "org-gnome-epiphany"
        "github-desktop"
        "org-gnome-baobab"
        "steam"
        "yelp"
        "gnome-wellbeing-panel"
      ];
    };

    "desktop/notifications/application/discord-canary" = {
      application-id = "discord-canary.desktop";
    };

    "desktop/notifications/application/discord" = {
      application-id = "discord.desktop";
    };

    "desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "desktop/notifications/application/gnome-network-panel" = {
      application-id = "gnome-network-panel.desktop";
    };

    "desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "desktop/notifications/application/gnome-wellbeing-panel" = {
      application-id = "gnome-wellbeing-panel.desktop";
    };

    "desktop/notifications/application/org-gnome-baobab" = {
      application-id = "org.gnome.baobab.desktop";
    };

    "desktop/notifications/application/org-gnome-clocks" = {
      application-id = "org.gnome.clocks.desktop";
    };

    "desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "desktop/notifications/application/org-gnome-epiphany" = {
      application-id = "org.gnome.Epiphany.desktop";
    };

    "desktop/notifications/application/org-gnome-extensions-desktop" = {
      application-id = "org.gnome.Extensions.desktop.desktop";
    };

    "desktop/notifications/application/org-gnome-fileroller" = {
      application-id = "org.gnome.FileRoller.desktop";
    };

    "desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "desktop/notifications/application/org-gnome-tweaks" = {
      application-id = "org.gnome.tweaks.desktop";
    };

    "desktop/notifications/application/steam" = {
      application-id = "steam.desktop";
    };

    "desktop/peripherals/keyboard" = {
      numlock-state = false;
    };

    "desktop/peripherals/touchpad" = {
      click-method = "areas";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
    };

    "desktop/screensaver" = {
      lock-delay = mkUint32 30;
      lock-enabled = true;
    };

    "desktop/search-providers" = {
      disabled = [ "org.gnome.Software.desktop" ];
      sort-order = [
        "org.gnome.Settings.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
      theme-name = "__custom";
    };

    "desktop/wm/keybindings" = {
      activate-window-menu = [ "<Super>space" ];
      begin-move = [ ];
      begin-resize = [ ];
      close = [ "<Super>q" ];
      maximize = [ ];
      move-to-monitor-down = [ "<Alt><Super>Down" ];
      move-to-monitor-left = [ "<Alt><Super>Left" ];
      move-to-monitor-right = [ "<Alt><Super>Right" ];
      move-to-monitor-up = [ "<Alt><Super>Up" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-left = [ "<Shift><Super>Right" ];
      move-to-workspace-right = [ "<Shift><Super>Left" ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-windows = [ ];
      switch-windows-backward = [ ];
      toggle-fullscreen = [ "<Super>b" ];
      unmaximize = [ ];
    };

    "desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 10;
      resize-with-right-button = true;
    };

    "eog/view" = {
      background-color = "#1d2021";
    };

    "epiphany" = {
      ask-for-default = false;
    };

    "epiphany/state" = {
      is-maximized = false;
      window-position = mkTuple [
        (-1)
        (-1)
      ];
      window-size = mkTuple [
        1024
        768
      ];
    };

    "evince/default" = {
      window-ratio = mkTuple [
        (mkDouble "1.007889")
        (mkDouble "0.712682")
      ];
    };

    "evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "gnome-system-monitor" = {
      current-tab = "resources";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-height = 1025;
      window-state = mkTuple [
        700
        500
      ];
      window-width = 846;
    };

    "gnome-system-monitor/disktreenew" = {
      col-1-visible = true;
      col-1-width = 178;
      col-6-visible = true;
      col-6-width = 0;
    };

    "gnome-system-monitor/proctree" = {
      col-26-visible = false;
      col-26-width = 0;
      columns-order = [
        0
        1
        2
        3
        4
        6
        8
        9
        10
        11
        12
        13
        14
        15
        16
        17
        18
        19
        20
        21
        22
        23
        24
        25
        26
      ];
      sort-col = 8;
      sort-order = 0;
    };

    "mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      output-luminance = mkArray "(ssssud)" [ ];
      workspaces-only-on-primary = false;
    };

    "mutter/keybindings" = {
      toggle-tiled-left = [ ];
      toggle-tiled-right = [ ];
    };

    "nautilus/compression" = {
      default-compression-format = "tar.xz";
    };

    "nautilus/preferences" = {
      click-policy = "single";
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
      show-create-link = true;
      show-delete-permanently = true;
    };

    "nautilus/window-state" = {
      initial-size = mkTuple [
        846
        1025
      ];
      initial-size-file-chooser = mkTuple [
        890
        550
      ];
      maximized = false;
    };

    "nm-applet" = {
      disable-disconnected-notifications = true;
    };

    "nm-applet/eap/022163dc-8595-4c8a-ad7b-ea70157bcc82" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "nm-applet/eap/5cc7fad6-0fa4-4474-9a16-b21cef0dee33" = {
      ignore-ca-cert = true;
      ignore-phase2-ca-cert = false;
    };

    "portal/filechooser/org/gnome/Settings" = {
      last-folder-path = "~/Media";
    };

    "settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
    };

    "settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
      search = [ ];
    };

    "settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>r";
      command = "wofi -S drun -Ddrun-disable_prime=true     ";
      name = "Run Menu";
    };

    "settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>Return";
      command = "bash -c \"\$TERMINAL\"";
      name = "Launch Terminal";
    };

    "settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>d";
      command = "nautilus";
      name = "Open File Manager";
    };

    "settings-daemon/plugins/power" = {
      power-button-action = "hibernate";
      sleep-inactive-ac-timeout = 1200;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-timeout = 900;
      sleep-inactive-battery-type = "suspend";
    };

    "shell" = {
      app-picker-layout = "[{'org.gnome.Geary.desktop': <{'position': <0>}>, 'org.gnome.Contacts.desktop': <{'position': <1>}>, 'org.gnome.Weather.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Maps.desktop': <{'position': <4>}>, 'org.gnome.Photos.desktop': <{'position': <5>}>, 'org.gnome.Totem.desktop': <{'position': <6>}>, 'org.gnome.Calculator.desktop': <{'position': <7>}>, 'simple-scan.desktop': <{'position': <8>}>, 'org.gnome.Settings.desktop': <{'position': <9>}>, 'gnome-system-monitor.desktop': <{'position': <10>}>, 'yelp.desktop': <{'position': <11>}>, 'Utilities': <{'position': <12>}>, 'AnyDesk.desktop': <{'position': <14>}>, 'btop.desktop': <{'position': <15>}>, 'org.gnome.Calendar.desktop': <{'position': <16>}>, 'discord.desktop': <{'position': <17>}>, 'org.gnome.Extensions.desktop': <{'position': <18>}>, 'firefox.desktop': <{'position': <19>}>, 'github-desktop.desktop': <{'position': <20>}>, 'gparted.desktop': <{'position': <21>}>, 'org.pipewire.Helvum.desktop': <{'position': <22>}>, 'htop.desktop': <{'position': <23>}>}, {'startcenter.desktop': <{'position': <0>}>, 'base.desktop': <{'position': <1>}>, 'calc.desktop': <{'position': <2>}>, 'draw.desktop': <{'position': <3>}>, 'impress.desktop': <{'position': <4>}>, 'math.desktop': <{'position': <5>}>, 'writer.desktop': <{'position': <6>}>, 'cups.desktop': <{'position': <7>}>, 'org.gnome.Music.desktop': <{'position': <8>}>, 'nixos-manual.desktop': <{'position': <9>}>, 'com.obsproject.Studio.desktop': <{'position': <10>}>, 'p3x-onenote.desktop': <{'position': <11>}>, 'com.github.jeromerobert.pdfarranger.desktop': <{'position': <12>}>, 'psensor.desktop': <{'position': <13>}>, 'org.qbittorrent.qBittorrent.desktop': <{'position': <14>}>, 'org.gnome.Software.desktop': <{'position': <15>}>, 'smartcode-stremio.desktop': <{'position': <16>}>, 'org.gnome.TextEditor.desktop': <{'position': <17>}>, 'org.gnome.Tour.desktop': <{'position': <18>}>, 'code.desktop': <{'position': <19>}>, 'vlc.desktop': <{'position': <20>}>, 'xterm.desktop': <{'position': <21>}>}]";
      command-history = [
        "ls"
        "r"
        "gnome-shell --version"
        "gnome-extensions reload org/gnome/shell/extensions/burn-my-windows"
        "kitty"
      ];
      disable-user-extensions = false;
      disabled-extensions = [ "burn-my-windows@schneegans.github.com" ];
      enabled-extensions = [
        "clipboard-history@alexsaveau.dev"
        "hibernate-status@dromi"
        "trayIconsReloaded@selfmade.pl"
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "xwayland-indicator@swsnr.de"
        "forge@jmmaranan.com"
        "Vitals@CoreCoding.com"
        "clipboard-indicator@tudmotu.com"
        "appmenu-is-back@fthx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Geary.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Music.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "42.4";
    };

    "shell/app-switcher" = {
      current-workspace-only = false;
    };

    "shell/extensions/appindicator" = {
      icon-brightness = mkDouble "0.0";
      icon-contrast = mkDouble "2.7755575615628914e-17";
      icon-opacity = 255;
      icon-saturation = mkDouble "0.0";
      icon-size = 0;
      legacy-tray-enabled = true;
      tray-pos = "right";
    };

    "shell/extensions/blur-my-shell" = {
      pipelines = [
        (mkDictionaryEntry [
          "pipeline_default"
          [
            (mkDictionaryEntry [
              "name"
              (mkVariant "Default")
            ])
            (mkDictionaryEntry [
              "effects"
              (mkVariant [
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "native_static_gaussian_blur")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000000")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 30)
                      ])
                      (mkDictionaryEntry [
                        "brightness"
                        (mkVariant (mkDouble "0.6"))
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ]
        ])
        (mkDictionaryEntry [
          "pipeline_default_rounded"
          [
            (mkDictionaryEntry [
              "name"
              (mkVariant "Default rounded")
            ])
            (mkDictionaryEntry [
              "effects"
              (mkVariant [
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "native_static_gaussian_blur")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000001")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 30)
                      ])
                      (mkDictionaryEntry [
                        "brightness"
                        (mkVariant (mkDouble "0.6"))
                      ])
                    ])
                  ])
                ])
                (mkVariant [
                  (mkDictionaryEntry [
                    "type"
                    (mkVariant "corner")
                  ])
                  (mkDictionaryEntry [
                    "id"
                    (mkVariant "effect_000000000002")
                  ])
                  (mkDictionaryEntry [
                    "params"
                    (mkVariant [
                      (mkDictionaryEntry [
                        "radius"
                        (mkVariant 24)
                      ])
                    ])
                  ])
                ])
              ])
            ])
          ]
        ])
      ];
      settings-version = 2;
    };

    "shell/extensions/blur-my-shell/appfolder" = {
      brightness = mkDouble "0.6";
      sigma = 30;
    };

    "shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = mkDouble "0.6";
      pipeline = "pipeline_default_rounded";
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };

    "shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
    };

    "shell/extensions/blur-my-shell/panel" = {
      brightness = mkDouble "0.6";
      pipeline = "pipeline_default";
      sigma = 30;
    };

    "shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "shell/extensions/blur-my-shell/window-list" = {
      brightness = mkDouble "0.6";
      sigma = 30;
    };

    "shell/extensions/clipboard-indicator" = {
      disable-down-arrow = true;
      history-size = 200;
    };

    "shell/extensions/forge" = {
      css-last-update = mkUint32 37;
      css-updated = "1754169536805";
      focus-border-toggle = true;
      focus-on-hover-enabled = true;
      move-pointer-focus-enabled = true;
      tiling-mode-enabled = true;
      window-gap-hidden-on-single = true;
      window-gap-size = mkUint32 2;
      window-gap-size-increment = mkUint32 1;
    };

    "shell/extensions/forge/keybindings" = {
      con-split-horizontal = [ "<Super>z" ];
      con-split-layout-toggle = [ "<Super>g" ];
      con-split-vertical = [ "<Super>v" ];
      con-stacked-layout-toggle = [ "<Shift><Super>s" ];
      con-tabbed-layout-toggle = [ "<Shift><Super>t" ];
      con-tabbed-showtab-decoration-toggle = [ "<Control><Alt>y" ];
      focus-border-toggle = [ "<Super>x" ];
      mod-mask-mouse-tile = "None";
      prefs-tiling-toggle = [ "<Super>w" ];
      window-focus-down = [ "<Super>Down" ];
      window-focus-left = [ "<Super>Left" ];
      window-focus-right = [ "<Super>Right" ];
      window-focus-up = [ "<Super>Up" ];
      window-gap-size-decrease = [ "<Control><Super>minus" ];
      window-gap-size-increase = [ "<Control><Super>plus" ];
      window-move-down = [ ];
      window-move-left = [ ];
      window-move-right = [ ];
      window-move-up = [ ];
      window-resize-bottom-decrease = [ "<Shift><Control><Super>i" ];
      window-resize-bottom-increase = [ "<Control><Super>u" ];
      window-resize-left-decrease = [ "<Shift><Control><Super>o" ];
      window-resize-left-increase = [ "<Control><Super>y" ];
      window-resize-right-decrease = [ "<Shift><Control><Super>y" ];
      window-resize-right-increase = [ "<Control><Super>o" ];
      window-resize-top-decrease = [ "<Shift><Control><Super>u" ];
      window-resize-top-increase = [ "<Control><Super>i" ];
      window-snap-center = [ "<Control><Alt>c" ];
      window-snap-one-third-left = [ "<Control><Alt>d" ];
      window-snap-one-third-right = [ "<Control><Alt>g" ];
      window-snap-two-third-left = [ "<Control><Alt>e" ];
      window-snap-two-third-right = [ "<Control><Alt>t" ];
      window-swap-down = [ "<Shift><Super>Down" ];
      window-swap-last-active = [ ];
      window-swap-left = [ "<Shift><Super>Left" ];
      window-swap-right = [ "<Shift><Super>Right" ];
      window-swap-up = [ "<Shift><Super>Up" ];
      window-toggle-always-float = [ "<Shift><Super>f" ];
      window-toggle-float = [ "<Super>f" ];
      workspace-active-tile-toggle = [ "<Shift><Super>w" ];
    };

    "shell/extensions/hibernate-status-button" = {
      show-hybrid-sleep-dialog = false;
    };

    "shell/extensions/rounded-window-corners" = {
      custom-rounded-corner-settings = "@a{sv} {}";
      global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <false>, 'fullscreen': <false>}>, 'border_radius': <uint32 12>, 'smoothing': <uint32 0>}";
      settings-version = mkUint32 5;
    };

    "shell/extensions/tilingshell" = {
      last-version-name-installed = "16.4";
      layouts-json = "[{\"id\":\"Layout 1\",\"tiles\":[{\"x\":0,\"y\":0,\"width\":0.22,\"height\":0.5,\"groups\":[1,2]},{\"x\":0,\"y\":0.5,\"width\":0.22,\"height\":0.5,\"groups\":[1,2]},{\"x\":0.22,\"y\":0,\"width\":0.56,\"height\":1,\"groups\":[2,3]},{\"x\":0.78,\"y\":0,\"width\":0.22,\"height\":0.5,\"groups\":[3,4]},{\"x\":0.78,\"y\":0.5,\"width\":0.22,\"height\":0.5,\"groups\":[3,4]}]},{\"id\":\"Layout 2\",\"tiles\":[{\"x\":0,\"y\":0,\"width\":0.22,\"height\":1,\"groups\":[1]},{\"x\":0.22,\"y\":0,\"width\":0.56,\"height\":1,\"groups\":[1,2]},{\"x\":0.78,\"y\":0,\"width\":0.22,\"height\":1,\"groups\":[2]}]},{\"id\":\"Layout 3\",\"tiles\":[{\"x\":0,\"y\":0,\"width\":0.33,\"height\":1,\"groups\":[1]},{\"x\":0.33,\"y\":0,\"width\":0.67,\"height\":1,\"groups\":[1]}]},{\"id\":\"Layout 4\",\"tiles\":[{\"x\":0,\"y\":0,\"width\":0.67,\"height\":1,\"groups\":[1]},{\"x\":0.67,\"y\":0,\"width\":0.33,\"height\":1,\"groups\":[1]}]}]";
      overridden-settings = ''
        {}
      '';
      selected-layouts = [
        [ "Layout 1" ]
        [ "Layout 1" ]
        [ "Layout 1" ]
      ];
      snap-assistant-animation-time = mkUint32 180;
      tile-preview-animation-time = mkUint32 80;
    };

    "shell/extensions/trayIconsReloaded" = {
      icon-size = 20;
      icons-limit = 4;
      tray-margin-left = 4;
    };

    "shell/extensions/user-theme" = {
      name = "Stylix";
    };

    "shell/extensions/vitals" = {
      alphabetize = true;
      fixed-widths = true;
      hide-icons = false;
      hide-zeros = false;
      hot-sensors = [
        "_memory_usage_"
        "_memory_swap_usage_"
        "_processor_usage_"
        "__temperature_avg__"
      ];
      icon-style = 0;
      menu-centered = false;
      position-in-panel = 0;
      show-battery = true;
      show-fan = false;
      show-gpu = true;
      show-memory = true;
      show-network = true;
      show-processor = true;
      show-storage = true;
      show-system = true;
      show-temperature = true;
      show-voltage = true;
      update-time = 10;
      use-higher-precision = false;
    };

    "shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
    };

    "shell/window-switcher" = {
      current-workspace-only = false;
    };

    "shell/world-clocks" = {
      locations = mkArray "v" [ ];
    };

    "software" = {
      check-timestamp = mkInt64 1754162293;
      first-run = false;
      flatpak-purge-timestamp = mkInt64 1754169433;
    };

    "tweaks" = {
      show-extensions-notice = false;
    };
  };
}
