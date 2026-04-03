# Den Framework Notes

This document captures repo-specific conventions for working in this Den-based flake.

## Core Structure

- The repo uses `inputs.import-tree ./modules` from `flake.nix` to discover modules.
- Den is wired in `modules/den.nix` via `inputs.den.flakeModule`.
- Most internal modules live under the `my` namespace (`my.*`).
- Angle-bracket imports (`<my/...>`, `<den/...>`) rely on `__findFile` being in the module args.

## Import and Namespace Rules

- If a module uses `<>` imports, include `__findFile` in the arg set.
- Prefer Den path imports (`<my/...>`) over direct attribute references when both are viable.
- In this repo, favor `<>` as the default style for module-to-module references.
- Keep namespace intent clear:
  - `my.profiles._.*` for host/user profile composition.
  - `my.apps._.*` for app modules and app bundles.
  - `my.desktops._.*` for desktop stacks and desktop-specific options.

## Den Composition Patterns

- Common profile pattern:

  - `den.lib.parametric.atLeast { includes = [ ... ]; }`

- Common module bundle pattern:

  - `my.<area>._.<name> = { includes = [ ... ]; ... }`

- Feature/provider pattern:

  - `my.<area>._.<name>.provides.<feature>.<scope> = { ... }`

- Scopes used here:

  - `nixos` for system-level configuration.
  - `homeManager` for user-level configuration.

## Per-System and Exported Packages

- `perSystem` blocks are used for flake package exports (e.g., `packages.myNoctalia`, `packages.myNiri`, `packages.myHyprland`).
- `nix run .#<name>` resolves flake `packages`, not host module options.
- Module option defaults do not automatically apply to standalone `nix run` packages.
- Use `self'.packages.<name>` inside modules when you want host config to consume the exported package.

## Desktop-Specific Notes

- Hyprland:
  - Normal/supported path is launching as a real session (TTY/DM), not nested inside another compositor.
  - `nix run .#myHyprland` inside COSMIC may fail due to compositor/backend limitations unrelated to Den wiring.
  - Theme/settings are now modeled as a Den module attr (e.g. `my.desktops._.hyprland._.themes._.default`) rather than a direct file import.

- Niri:
  - Works well with wrapper-modules integration in this repo.
  - Can reference `self'.packages.myNoctalia` for shell startup.

## File Layout Conventions In This Repo

- Apps are under `modules/apps/**` (there is no top-level `apps/` directory).
- Desktop modules are under `modules/desktops/**`.
- User aspects are in `modules/users/**`.
- Legacy/manual user package lists exist under `users/*.nix`; these are useful for discovering missing app modules/profiles.

## Practical Guidelines For Future Edits

- Before deleting `default.nix` aggregator files, ensure equivalent exported attrs/paths still exist.
- When moving modules, verify all `<my/...>` import paths still resolve.
- If changing profile structure, keep callers stable first, then migrate references.
- Validate with `nix flake check` (and `--impure` if you need untracked files during local iteration).
