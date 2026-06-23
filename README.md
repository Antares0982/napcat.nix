# napcat.nix

Fork from [chronocat.nix](https://github.com/Anillc/chronocat.nix)

Config directory: ./data/napcat/config

# Usage

## Quick start

```shell
nix run github:initialencounter/napcat.nix
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
