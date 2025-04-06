# /nixos/modules/zram.nix

{
  zramSwap = {
    enable = false;
    algorithm = "lz4";
    memoryPercent = 100;
    priority = 999;
  };
}
