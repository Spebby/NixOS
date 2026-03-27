{
  services = {
    flatpak.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    blueman.enable = true;
  };

  zramSwap = {
    enable = false;
    algorithm = "lz4";
    memoryPercent = 100;
    priority = 999;
  };
}
