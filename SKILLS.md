# Den Framework Notes

This document captures repo-specific conventions for working in this Den-based flake.

## Core Structure

- The repo uses `inputs.import-tree ./modules` from `flake.nix` to discover modules.
- Den is wired in `modules/den.nix` via `inputs.den.flakeModule`.
- Most internal modules live under the `my` namespace (`my.*`).
- Angle-bracket imports (`<my/...>`, `<den/...>`) rely on `__findFile` being in the module args.
- Den framework pipeline: `den.hosts`/`den.homes` -> context pipeline (`den.ctx`) -> resolved class modules -> flake outputs (`nixosConfigurations`, `darwinConfigurations`, `homeConfigurations`).

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

- Den auto-creates aspects from entities:
  - Host declarations generate host aspects.
  - Host users generate user aspects.
  - Standalone homes (`den.homes`) generate home aspects.

## Den Concepts (Detailed)

- Aspects:
  - An aspect is a composable feature bundle, not a host file.
  - Aspects can carry multiple Nix classes at once (for example `nixos` + `homeManager`).
  - Typical keys are owned class configs (`nixos`, `homeManager`, etc.), `includes`, and `provides`.
  - Den auto-generates aspects for declared hosts/users/homes, and repo files incrementally extend those aspects.

- Parametric behavior:
  - Includes can be plain attrsets, static functions, or parametric functions.
  - Parametric functions receive context (`{ host }`, `{ host, user }`, `{ home }`) based on their argument shape.
  - This is what enables one feature module to adapt by host/user metadata without copy-pasting host-specific modules.
  - Static include helpers can use `{ class, aspect-chain }` to reason about class resolution and include path.

- Provides:
  - `provides` creates named sub-aspects under an aspect DAG.
  - Practical reference forms: `den.aspects.foo.provides.bar` and shorthand/leaf forms (repo commonly uses `_`).
  - Use `provides` for feature slices that should be imported independently (e.g., editors subset of dev tools).

- Batteries (`den.provides`, alias `den._`):
  - Batteries are Den's built-in reusable aspects.
  - They are included like normal aspects and can be parametric.
  - Use batteries for common integration plumbing, then compose custom `my.*` aspects on top.

- Custom Nix classes:
  - Den is class-agnostic; `nixos`, `homeManager`, and `darwin` are common classes, not hard limits.
  - You can define and forward additional classes for other module domains/outputs.
  - This same mechanism is how aspect contributions can feed flake-level outputs like `packages`/`checks` when wired.

- Namespaces:
  - Namespaces package/share aspect libraries across repos via `den.ful.<namespace>`.
  - `den.namespace "my" true` wires a local namespace and enables `<my/...>` style usage.
  - Namespaces are the social/distribution layer for reusable aspect libraries.

- Angle bracket syntax (`<>`):
  - Backed by `den.lib.__findFile`; requires `_module.args.__findFile = den.lib.__findFile`.
  - Any module using `<>` must include `__findFile` in its argument set.
  - Resolution order from docs:
    - `<den.x.y>` -> `config.den.x.y`
    - `<aspect>` -> `config.den.aspects.aspect`
    - `<aspect/sub>` -> `config.den.aspects.aspect.provides.sub`
    - `<namespace>` -> `config.den.ful.namespace`
  - In this repo, default style preference is to use `<>` paths when viable.

## Per-System and Exported Packages

- `perSystem` blocks are used for flake package exports (e.g., `packages.myNoctalia`, `packages.myNiri`, `packages.myHyprland`).
- `nix run .#<name>` resolves flake `packages`, not host module options.
- Module option defaults do not automatically apply to standalone `nix run` packages.
- Use `self'.packages.<name>` inside modules when you want host config to consume the exported package.

## Rebuild and Activation Flow

- Den does not replace standard rebuild tools; you still use normal NixOS/HM commands.
- For hosts in `den.hosts`, primary flow is `nixos-rebuild switch --flake .#<host>` (or `build`).
- Equivalent build path is `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.
- Host-managed Home Manager users are integrated into the host eval and apply via `nixos-rebuild`.
- Standalone HM is done via `den.homes`, which produces `homeConfigurations.<name>`.
- For standalone HM, `home-manager switch --flake` targets `homeConfigurations` outputs.
- Naming a standalone home as `<user>@<hostname>` enables home-manager auto-selection behavior.

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
- In this repo, there are currently no explicit top-level `homeConfigurations` outputs declared by user-defined `den.homes`; HM is primarily host-integrated via `den.hosts.*.users.*`.

## Practical Guidelines For Future Edits

- Before deleting `default.nix` aggregator files, ensure equivalent exported attrs/paths still exist.
- When moving modules, verify all `<my/...>` import paths still resolve.
- If changing profile structure, keep callers stable first, then migrate references.
- Validate with `nix flake check` (and `--impure` if you need untracked files during local iteration).

## Reoccurring bugs

- If network is completely failing (wifi/ethernet broken), double check that hardware.enableRedistributableFirmware is set true.
