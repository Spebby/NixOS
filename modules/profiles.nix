{ __findFile, ... }: {
  my.profiles._ = {
    workstation.includes = [
      <my/boot>
      <my/system/networking>
      <my/flatpak>
      <my/printing>
      <my/ssh/client>
      <my/system/openssl>
      <my/system/virt/podman>
    ];
    desktop.includes = [
      <my/profiles/workstation>
      <my/ssh/server>
      <my/system/networking/wol>
      <my/system/acpid>
      <my/system/performance/max>
    ];
    laptop.includes = [
      <my/profiles/workstation>
      <my/system/power-management>
      <my/system/acpid>
      <my/system/performance/responsive>
    ];
  };
}
