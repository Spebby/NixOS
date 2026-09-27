{
  my.ai._.llama.nixos =
    { pkgs, ... }:
    let
      llama = pkgs.llama-cpp.override { cudaSupport = true; };
      llama-server = "${llama}/bin/llama-server";
    in
    {
      # CUDA is unfree (you probably already have this set for the NVIDIA driver)
      nixpkgs.config.allowUnfree = true;

      services.llama-swap = {
        enable = true;
        port = 8080;
        openFirewall = false; # llama-swap has no auth, so flip this only if you need LAN access

        settings = {
          # First request downloads ~20GB from Hugging Face, so allow plenty of time
          healthCheckTimeout = 3600;

          models = {
            # Dense 27B: best reasoning, slowest. Q4 doesn't fit in 16GB,
            # so some layers spill to system RAM.
            "qwen3.8-27b" = {
              ttl = 900; # unload after 15 min idle
              cmd = ''
                ${llama-server} --port ''${PORT} \
                  -hf bartowski/Qwen3.8-27B-GGUF:Q4_K_M \
                  --jinja -fa on \
                  -c 65536 -ctk q8_0 -ctv q8_0 \
                  -ngl 38 \
                  --temp 0.6 --top-p 0.95 --top-k 20
              '';
            };

            # MoE 35B (3B active): experts live in system RAM, the rest on the GPU
            "ornith-1.5-35b-a3b" = {
              ttl = 900;
              cmd = ''
                ${llama-server} --port ''${PORT} \
                  --hf-repo AtomicChat/Ornith-1.5-35B-A3B-GGUF \
                  --hf-file Ornith-1.5-35B-A3B-AD-Q5_K-Q4_K.gguf \
                  --jinja -fa on \
                  -c 65536 -ctk q8_0 -ctv q8_0 \
                  --parallel 1 \
                  -ngl 99 --n-cpu-moe 24 \
                  --temp 0.6 --top-p 0.95 --top-k 20
              '';
            };

            # 400MB test model
            "qwen2.5-0.5b-test" = {
              ttl = 300;
              cmd = ''
                ${llama-server} --port ''${PORT} \
                  -hf Qwen/Qwen2.5-0.5B-Instruct-GGUF:Q4_K_M \
                  --jinja \
                  -c 4096 \
                  -ngl 99
              '';
            };
          };
        };
      };
    };
}
