# napcat.nix

Fork from [chronocat.nix](https://github.com/Anillc/chronocat.nix)

Config directory: ./data/napcat/config

QQ is frozen at `3.2.34-2026-09-24` and NapCat at `v4.18.42`.
Both architectures use archived release files and fixed SHA-256 hashes in
`src/sources.nix`. Flake updates can update nixpkgs and runtime libraries,
but cannot update these QQ/NapCat binaries. QQ auto-updates are disabled.
GitHub workflows and the source updater have been removed.

Check the pins against a nixpkgs checkout:

```shell
nix eval --impure --expr 'import ./tests/pins.nix { nixpkgs = /path/to/nixpkgs; }'
```

# Usage

## Quick start

```shell
nix run github:Antares0982/napcat.nix
```

## setup nix

[NixOS](https://nixos.org/download/)

```shell
sh <(curl -L https://nixos.org/nix/install) --daemon
```

```shell
mkdir -p ~/.config/nix && touch ~/.config/nix/nix.conf
vi ~/.config/nix/nix.conf
# Write the following:
experimental-features = nix-command
```

```shell
nix flake update  --extra-experimental-features flakes
nix build --extra-experimental-features flakes
nix run --extra-experimental-features flakes
```
