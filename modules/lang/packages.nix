{ lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      lang = rec {
        c = pkgs.buildEnv {
          name = "lang-c";
          paths = with pkgs; [
            clang
            cmake
            gnumake
            meson
          ];
        };

        cpp = pkgs.buildEnv {
          name = "lang-cpp";
          paths = with pkgs; [
            gcc
            cmake
            gnumake
            meson
          ];
        };

        rust = pkgs.buildEnv {
          name = "lang-rust";
          paths = with pkgs; [
            rustc
            cargo
            rustfmt
            clippy
            rust-analyzer
          ];
        };

        zig = pkgs.buildEnv {
          name = "lang-zig";
          paths = [
            pkgs.zig
            pkgs.zls
          ];
        };

        csharp = pkgs.buildEnv {
          name = "lang-csharp";
          paths =
            with pkgs;
            [
              dotnet-sdk_8
              dotnet-runtime_8
              dotnet-aspnetcore_8
            ]
            ++ lib.optionals pkgs.stdenv.isLinux [
              omnisharp-roslyn
              mono
            ];
        };

        jsTs = pkgs.buildEnv {
          name = "lang-js-ts";
          paths = with pkgs; [
            nodejs
            typescript
            typescript-language-server
            eslint
            prettier
            yarn
            pnpm
          ];
        };

        python = pkgs.buildEnv {
          name = "lang-python";
          paths = with pkgs; [
            python311
            pyright
            ruff
          ];
        };

        odin = pkgs.buildEnv {
          name = "lang-odin";
          paths = [
            pkgs.odin
            pkgs.ols
          ];
        };

        full = pkgs.symlinkJoin {
          name = "lang-full";
          paths = [
            c
            cpp
            rust
            zig
            csharp
            jsTs
            python
            odin
          ];
        };
      };
    in
    {
      packages = {
        "lang-c" = lang.c;
        "lang-cpp" = lang.cpp;
        "lang-rust" = lang.rust;
        "lang-zig" = lang.zig;
        "lang-csharp" = lang.csharp;
        "lang-js-ts" = lang.jsTs;
        "lang-python" = lang.python;
        "lang-odin" = lang.odin;
        "lang-full" = lang.full;
      };
    };
}
