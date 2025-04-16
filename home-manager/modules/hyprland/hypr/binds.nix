{ pkgs, ... }:

let
  booksDir = "$HOME/Downloads/books";
  booksScript = pkgs.writeScriptBin "open_books" ''
    #!/bin/sh

    BOOKS_DIR="${booksDir}"

    BOOK=$(find "$BOOKS_DIR" -type f \( -iname "*.pdf" -o -iname "*.epub" -o -iname "*.djvu" \) | wofi --dmenu --prompt "Select a book" --width 1200 --height 400)

    if [[ -n "$BOOK" ]]; then
        zathura "$BOOK" &
    else
        echo "No book selected."
    fi
  '';
in
{
  home.packages = [
    booksScript
    pkgs.bemoji
    pkgs.cliphist

    pkgs.hyprpicker
    pkgs.hyprshade
    pkgs.grimblast
    pkgs.swappy

    # Testing binds
    pkgs.wev
  ];

  wayland.windowManager.hyprland.settings = {
    bind = [
      # Core Functions
      "$mainMod,       Q, exec, hypr-kill-or-hide-steam"
      "$mainMod CTRL,  ESCAPE, exit,"

      "$mainMod,       L, exec, loginctl lock-session"
      "$mainMod,       C, exec, hyprpicker -an"
      #"$mainMod,       B, exec, pkill -SIGUSR2 waybar"
      #"$mainMod SHIFT, B, exec, pkill -SIGUSR1 waybar"
      "$mainMod,       B, fullscreen, 1"
      "$mainMod,       N, exec, swaync-client -t"
      ", Print, exec, grimblast --notify --freeze copysave area | swappy -f -"

      # Utilities
      "$mainMod,       RETURN, exec, $terminal" # ex. Kitty/Foot
      "$mainMod,       R, exec, $menu --show drun" # ex. Wofi
      "$mainMod,       D, exec, $fileManager" # ex. Dolphin
      "$mainMod,       E, exec, bemoji -cn"
      "$mainMod,       V, exec, cliphist list | $menu --dmenu | cliphist decode | wl-copy"
      "$mainMod,       W, exec, ${booksScript}/bin/open_books"

      # Window Manipulation
      "$mainMod,       F, togglefloating,"
      "$mainMod,       G, pin,"
      "$mainMod,       H, togglesplit,"

      # Moving focus
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Moving windows
      "$mainMod SHIFT, left,  swapwindow, l"
      "$mainMod SHIFT, right, swapwindow, r"
      "$mainMod SHIFT, up,    swapwindow, u"
      "$mainMod SHIFT, down,  swapwindow, d"

      # Resize windows                      X  Y
      "$mainMod CTRL, left,  resizeactive, -60 0"
      "$mainMod CTRL, right, resizeactive,  60 0"
      "$mainMod CTRL, up,    resizeactive,  0 -60"
      "$mainMod CTRL, down,  resizeactive,  0  60"

      # Eventually, adding support for split-workspace would be good.
      # Switching workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod, P, togglespecialworkspace, popupterm"

      # Scroll Wheel to switch workplaces
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

      # Moving windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
      "$mainMod SHIFT, P, movetoworkspace, special:popupterm"
      "$mainMod, SPACE, layoutmsg, swapwithmaster"

      # I don't like the command, but movetoworkspacesilent may be useful in some cases.

      # Special Workspaces

      # Scratchpad
      # "$mainMod,       P, togglespecialworkspace,  magic"
      # "$mainMod SHIFT, P, movetoworkspace, special:magic"
    ];

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp,   exec, brightnessctl s 10%+"
      ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"

      # My keyboard has an audio nob, and I'd like to control the brightness
      # w/ it sometimes.
      "SHIFT,XF86AudioRaiseVolume,  exec, brightnessctl s 10%+"
      "SHIFT,XF86AudioLowerVolume,  exec, brightnessctl s 10%-"
      "$mainMod, bracketright, exec, brightnessctl s 10%+"
      "$mainMod, bracketleft,  exec, brightnessctl s 10%-"
    ];

    # Audio playback
    bindl = [
      ", XF86AudioNext,  exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay,  exec, playerctl play-pause"
      ", XF86AudioPrev,  exec, playerctl previous"
    ];
  };
}
