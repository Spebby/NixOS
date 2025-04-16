{ pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      label = [
        {
          monitor = "$mainMonitor";
          halign = "center";
          valign = "center";
          position = "0, 80";

          text =
            let
              hourScript = pkgs.writeShellScriptBin "hyprlock-hours" ''
                			echo "<b><big>$(date +"%H")</big></b>"	
                			'';
            in
            "cmd[update:1000] ${hourScript}/bin/hyprlock-hours";
          font_size = 128;
          font_family = "JetBrains Mono";
          color = "rgba(235, 219, 178, 1.0)";

          shadow_passes = 1;
        }
        {
          monitor = "";
          halign = "center";
          valign = "center";
          position = "0, -80";
          text =
            let
              minScript = pkgs.writeShellScriptBin "hyprlock-minutes" ''
                			echo "<b><big>$(date +"%M")</big></b>"	
                			'';
            in
            "cmd[update:1000] ${minScript}/bin/hyprlock-minutes";
          font_size = 128;
          font_family = "JetBrains Mono";
          color = "rgba(235, 219, 178, 1.0)";
          shadow_passes = 1;
        }

        # Day
        {
          monitor = "";
          halign = "center";
          valign = "center";
          position = "0, -170";

          text =
            let
              dateScript = pkgs.writeShellScriptBin "hyprlock-date" ''
                			echo "<b><big>$(date +"%d %b")</big></b>"	
                			'';
            in
            "cmd[update:1000] ${dateScript}/bin/hyprlock-date";
          font_size = 16;
          font_family = "JetBrains Mono";
          color = "rgba(235, 219, 178, 1.0)";
          shadow_passes = 1;
        }
        {
          monitor = "";
          halign = "center";
          valign = "center";
          position = "0, -190";

          text =
            let
              dayScript = pkgs.writeShellScriptBin "hyprlock-day" ''
                			echo "<b><big>$(date +"%A")</big></b>"	
                			'';
            in
            "cmd[update:1000] ${dayScript}/bin/hyprlock-day";
          font_size = 16;
          font_family = "JetBrains Mono";
          color = "rgba(235, 219, 178, 1.0)";
          shadow_passes = 1;
        }
      ];

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 4;
        }
      ];

      input-field = [
        {
          monitor = "";
          halign = "center";
          valign = "bottom";
          position = "0, 60";

          size = "250, 50";
          outline_thickness = 3;

          dots_size = 0.2;
          dots_spacing = 1.00;
          dots_center = true;

          font_color = "rgb(235, 219, 178)";
          inner_color = "rgb(40, 40, 40)";
          outer_color = "rgb(60, 56, 54)";

          fade_on_empty = true;
          hide_input = false;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 1;
        }
      ];
    };
  };
}
