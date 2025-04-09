# /users/home-manager/thom.nix

{ pkgs, ... }:

let
  allowedSigners = "${builtins.getEnv "HOME"}/.ssh/allowed_signers";
in
{
  home = {
    packages = with pkgs; [ lutris ];
    file."${allowedSigners}".text =
      "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOJHJvth1usDlafKm6M61C8nTy+YgVe7uizcFmqXqp3A thommott@proton.me";
  };

  programs.git = {
    enable = true;
    userName = "Thom Mott";
    userEmail = "thommott@proton.me";
    extraConfig = {
      gpg.ssh.allowedSignersFile = allowedSigners;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    signing = {
      key = "~/.ssh/NixOS.pub";
      signByDefault = true;
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2; # hyprland specific
  };
}
