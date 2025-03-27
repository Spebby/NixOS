# /lib/makeHome.nix

{ inputs, stateVersion, lib }:

{ pkgs
, user
, hostModules ? []
, ...
}@args:

inputs.home-manager.lib.homeManagerConfiguration {
	inherit pkgs;

	modules = let
		baseModules = [
			../home-manager
			({ lib, ...}: {
				home.stateVersion = lib.mkDefault stateVersion;
			})
		];
	in baseModules ++ ( lib.flatten hostModules);

	extraSpecialArgs = {
		inherit inputs user stateVersion;
	};
}
