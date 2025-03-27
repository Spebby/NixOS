# /hosts/hosts.nix

{
	rosso = {
		hostname = "rosso";
		system = "x86_64-linux";
		config = import ./rosso/configuration.nix;
		users = [
			"thom"
			"max"
		];
		extraModules = [];
	};

	#desktop = {
	#	namename = "desktop";
	#	system = "x86_64-linux";
	#	config = import ./desktop/configuration.nix;
	#   users = [
	#		"thom"
	#		"max"
	#   ];
	#	extraModules = [];
	#};
}
