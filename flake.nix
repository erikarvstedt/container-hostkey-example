# See how this flake is used in ./usage.sh
{
  inputs.extra-container.url = "github:erikarvstedt/extra-container";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { extra-container, ... }@inputs:
    extra-container.inputs.flake-utils.lib.eachSystem extra-container.lib.supportedSystems (system: {
      packages.default = extra-container.lib.buildContainers {
        # The system of the container host
        inherit system;

        # Optional: Set nixpkgs.
        # If unset, the nixpkgs input of extra-container flake is used
        nixpkgs = inputs.nixpkgs;

        config = {
          containers.sshkey-demo = {
            extra.addressPrefix = "10.250.0";

            bindMounts.src = {
              # FIXME:
              # Add the realpath of this flake repo here
              hostPath = "<THIS-REPO>/host-key";
              mountPoint = "/host-key";
            };

            # `specialArgs` is available in nixpkgs > 22.11
            # This is useful for importing flakes from modules (see nixpkgs/lib/modules.nix).
            # specialArgs = { inherit inputs; };

            config = { pkgs, lib, ... }: {
              services.openssh = {
                # Only helpful for debugging service startup.
                # Can be removed in production.
                startWhenNeeded = false;

                enable = true;
                passwordAuthentication = false;
                hostKeys = lib.mkForce [
                  {
                    path = "/host-key/ssh_host_ed25519_key";
                    type = "ed25519";
                  }
                ];
              };
            };
          };
        };
      };
    });
}
