{
  my.ai._.ollama.nixos =
    { config, ... }:
    {
      services.ollama = {
        inherit (config.ollama) enable;
        user = "ollama";
        host = "[::]";
        openFirewall = true;
        package = "cuda";
      };
    };
}
