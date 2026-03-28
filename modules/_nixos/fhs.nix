{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Create an FHS environment using the command `fhs`, enabling the execution of non-NixOS packages in NixOS!
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
      pkgs.buildFHSEnv (
        base
        // {
          name = "fhs";
          targetPkgs =
            pkgs:
            # pkgs.buildFHSEnv provides only a minimal FHS environment,
            # lacking many basic packages needed by most software.
            # Therefore, we need to add them manually.
            #
            # pkgs.appimageTools provides basic packages required by most software.
            (base.targetPkgs pkgs)
            ++ (with pkgs; [
              pkg-config
              ncurses
              zsh
              # Feel free to add more packages here if needed.
            ]);
          profile = "export FHS=1";
          runScript = "zsh --login";
          extraOutputsToInstall = [ "dev" ];
        }
      )
    )
  ];
}
