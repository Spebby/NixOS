{
  my.ai._.ollama.nixos = {
    services.ollama = {
      enable = true;
      user = "ollama";
      host = "[::]";
      openFirewall = true;
    };
  };
}
