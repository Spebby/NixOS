{ config, lib, ... }:

let
  cfg = config.ollama;
in
{
  options.ollama = {
    enable = lib.mkEnableOption "Enable Ollama";
  };

  config = {
    services.ollama = {
      inherit (cfg) enable;
      loadModels = [
        "llama3.2:3b"
        "deepseek-r1:1.5b"
        "qwen2.5:7b"
      ];
      package = "cuda";
    };
  };
}
