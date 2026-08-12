{
  my.graphics.nixos = { pkgs-stable, ... }: {
    environment.systemPackages = with pkgs-stable; [
      corectrl
      nvtopPackages.full
      vulkan-tools
    ];
  };
}
