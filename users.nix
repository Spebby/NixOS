{ config, lib, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
     thom = {
       isNormalUser = true;
       extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
       packages = with pkgs; [
         tree
         firefox
       ];
    };
  };
}

