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
        <my/system/openssl>
      ];
    };
    desktop = den.lib.parametric.atLeast {
      includes = [
        <my/profiles/workstation>
        <my/ssh/server>
        <my/networking/wol>
        <my/system/acpid>
      ];
    };
    laptop = den.lib.parametric.atLeast {
      includes = [
        <my/profiles/workstation>
        <my/power-management>
        <my/system/acpid>
      ];
    };
  };
}
