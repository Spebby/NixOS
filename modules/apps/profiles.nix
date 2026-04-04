{ den, __findFile, ... }:
{
  my.profiles._ = {
    common-use = den.lib.parametric.atLeast {
      includes = [
        <my/apps/discord>
        <my/apps/firefox>
        <my/apps/fun>
        <my/apps/hardware-tools>
      ];
    };

    gaming.provides = {
      core = den.lib.parametric.atLeast {
        includes = [
          <my/apps/steam>
          <my/apps/protonup>
          <my/apps/prismlauncher>
        ];
      };

      emulators = den.lib.parametric.atLeast { includes = [ <my/apps/emulators> ]; };

      all = den.lib.parametric.atLeast {
        includes = [
          <my/profiles/gaming/core>
          <my/profiles/gaming/emulators>
        ];
      };
    };

    art.provides = {
      all = den.lib.parametric.atLeast {
        includes = [
          <my/profiles/art/modelling>
          <my/profiles/art/drawing>
        ];
      };

      modelling = den.lib.parametric.atLeast { includes = [ <my/apps/art/blender> ]; };
      drawing = den.lib.parametric.atLeast { includes = [ <my/apps/art/aseprite> ]; };
    };

    dev.provides = {
      all = den.lib.parametric.atLeast {
        includes = [
          <my/profiles/dev/editors>
          <my/profiles/dev/tools>
          <my/profiles/dev/games>
        ];
      };

      editors = den.lib.parametric.atLeast {
        includes = [
          <my/apps/editors/zed>
          <my/apps/editors/vim>
          <my/apps/editors/vscode>
        ];
      };

      tools = den.lib.parametric.atLeast {
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

      games = den.lib.parametric.atLeast {
        includes = [
          <my/apps/engines/godot>
          <my/apps/engines/unity>
          <my/apps/editors/rider>
        ];
      };
    };

    desktop-utils = den.lib.parametric.atLeast {
      includes = [
        <my/apps/desktop-utils/home>
        <my/apps/audio-tools>
        <my/apps/diagnostics>
        <my/apps/ffmpeg>
      ];
    };

    theming = den.lib.parametric.atLeast {
      includes = [
        <my/apps/stylix>
      ];
    };

    math = den.lib.parametric.atLeast { includes = [ <my/apps/math> ]; };
  };
}
