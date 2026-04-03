{ den, __findFile, ... }:
{
  my.profiles._ = {
    common-use = den.lib.parametric.atLeast {
      includes = [
        <my/apps/discord>
        <my/apps/firefox>
        <my/apps/fun>
      ];
    };

    art.provides = {
      all = den.lib.parametric.atLeast {
        includes = [
          <my/profiles/dev/games>
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
          <my/profiles/dev/apps>
          <my/profiles/dev/system>
          <my/profiles/dev/editors>
          <my/profiles/dev/tools>
          <my/profiles/dev/games>
        ];
      };

      apps = den.lib.parametric.atLeast { includes = [ <my/apps/dev/python> ]; };
      system = den.lib.parametric.atLeast {
        includes = [
          <my/apps/dev/c>
          <my/apps/dev/odin>
          <my/apps/dev/zig>
          <my/apps/dev/common>
        ];
      };

      editors = den.lib.parametric.atLeast {
        includes = [
          <my/apps/editors/zed>
          <my/apps/editors/vim>
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
        <my/apps/audio-tools>
        <my/apps/diagnostics>
        <my/apps/ffmpeg>
      ];
    };

    theming = den.lib.parametric.atLeast {
      includes = [
        <my/apps/stylix>
        <my/apps/qt>
      ];
    };

    math = den.lib.parametric.atLeast {
      includes = [

      ];
    };
  };
}
