# /nixos/modules/bluetooth.nix

{
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = false;
	services.blueman.enable = true;
}
