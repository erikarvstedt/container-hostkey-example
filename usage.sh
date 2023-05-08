# The SSH host key was created like so:
ssh-keygen -t ed25519 -P '' -C none -f host-key/ssh_host_ed25519_key

# To check that the container is correctly picking up the host key,
# scan the pubkey of the running container...
nix run . -- --run ssh-keyscan sshkey-demo
# ...and compare it with the expected result
ssh-keygen -y -f host-key/ssh_host_ed25519_key

#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Container lifecycle

# Create and start container defined by ./flake.nix
nix run . -- create --start
# After changing ./flake.nix, you can also use this command to update
# the (running) container.
#
# The arguments after `--` are passed to the `extra-container` binary in PATH,
# while the flake is used for the container definitions.

# Use `nixos-container` to control the running container
sudo nixos-container run sshkey-demo -- hostname
sudo nixos-container root-login sshkey-demo

# Destroy container
nix run . -- destroy

#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Container shell
# Start an interactive shell in a new container
nix run . -- shell
nix run . # equivalent, because `shell` is used as the default command

# Run a single command in the container.
# The container is destroyed afterwards.
nix run . -- --run c hostname
nix run . -- shell --run c hostname # equivalent
nix run . -- --run bash -c 'curl --http0.9 $ip:50'

#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Usage via `nix build`
# 1. Build container
nix build . --out-link /tmp/container
# 2. Run container
extra-container shell /tmp/container

#―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Inspect container configs
nix eval . --apply 'sys: sys.containers.hostkey-demo.config.networking.hostName'
