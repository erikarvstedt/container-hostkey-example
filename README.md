A simple extra-container NixOS system that gets its SSH host key from the
container host via a bind mount.

*Warning*: Don't store the host key in a flake repo (as is the case here) until
https://github.com/NixOS/nix/pull/6530 is available

See [`./usage.sh`](./usage.sh).
