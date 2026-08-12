{
  my.bluetooth.nixos = { pkgs, ... }: {
    # ideapad_bluetooth is softblocked on rfkill
    # so unblock it manually
    systemd.services.unblock-ideapad-bluetooth = {
      description = "Clear ideapad_laptop platform rfkill block on Bluetooth";
      wantedBy = [ "multi-user.target" ];
      before = [ "bluetooth.service" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
