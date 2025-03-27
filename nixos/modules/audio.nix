# /nixos/modules/audio.nix

{
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		#jack.enable = true; # review if i actually need this one
	};
}
