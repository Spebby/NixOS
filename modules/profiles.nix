{ den, ... }:
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
        <my/boot/secure>
        <my/power-mgmt>
        <my/performance/responsive>
      ];
    };
    modern = den.lib.parametric.atLeast { includes = [ <my/bluetooth> ]; };
  };
}
