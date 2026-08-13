{ __findFile, ... }: {
  my.profiles._ = {
    common-use = {
      includes = [
        <my/apps/discord>
        <my/apps/firefox>
        <my/apps/hardware-tools>
      ];
    };

    gaming.provides = {
      core = {
        includes = [
          <my/apps/steam>
          <my/apps/protonup>
          <my/apps/prismlauncher>
        ];
      };

      emulators = {
        includes = [ <my/apps/emulators> ];
      };

      all = {
        includes = [
          <my/profiles/gaming/core>
          <my/profiles/gaming/emulators>
        ];
      };
    };

    art.provides = {
      all = {
        includes = [
          <my/profiles/art/modelling>
          <my/profiles/art/drawing>
        ];
      };

      modelling = {
        includes = [ <my/apps/art/blender> ];
      };
      drawing = {
        includes = [ <my/apps/art/aseprite> ];
      };
    };

    dev.provides = {
      all = {
        includes = [
          <my/profiles/dev/editors>
          <my/profiles/dev/tools>
          <my/profiles/dev/games>
        ];
      };

      editors = {
        includes = [
          <my/apps/editors/zed>
          <my/apps/editors/vim>
        ];
      };

      tools = {
        includes = [
          <my/apps/git>
          <my/apps/terminal>
          <my/apps/shell>
          <my/apps/shell/tools>
          <my/apps/shell/tui>
          <my/apps/nix-tools>
          <my/apps/dev/localsend>
          <my/apps/dev/tooling>
        ];
      };

      games = {
        includes = [
          <my/apps/engines/godot>
          <my/apps/engines/unity>
          <my/apps/editors/rider>
        ];
      };
    };

    desktop-utils = {
      includes = [
        <my/apps/desktop-utils/home>
        <my/apps/audio-tools>
        <my/apps/diagnostics>
        <my/apps/ffmpeg>
      ];
    };

    theming = {
      includes = [ <my/apps/stylix> ];
    };

    fun = {
      includes = [
        <my/apps/fun/terminal>
        <my/apps/fun/graphical>
      ];
    };

    math = {
      includes = [ <my/apps/math> ];
    };
  };
}
