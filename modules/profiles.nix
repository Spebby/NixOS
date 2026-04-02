{ den, __findFile, ... }:
{
  my.profiles._ = {
    workstation = den.lib.parametric.atLeast {
      includes = [
        <my/boot>
        <my/networking>
        <my/flatpak>
        <my/printing>
        <my/ssh/client>
        <my/filesystems/ntfs>
        <my/xdg>
      ];
    };
    desktop = den.lib.parametric.atLeast {
      includes = [
        <my/profiles/workstation>
        <my/ssh/server>
        <my/performance/max>
        <my/networking/wol>
      ];
    };
    laptop = den.lib.parametric.atLeast {
      includes = [
        <my/profiles/workstation>
        <my/boot/graphical>
        <my/power-management>
        <my/performance/responsive>
      ];
    };

    modern = den.lib.parametric.atLeast {
      includes = [
        <my/bluetooth>
        <my/boot/graphical>
      ];
    };

    dev-tools = den.lib.parametric.atLeast {
      includes = [
        <my/apps/git>
        <my/apps/terminal>
        <my/apps/shell>
        <my/apps/shell/tools>
        <my/apps/shell/tui>
      ];
    };

  };
}
