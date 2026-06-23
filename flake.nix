{
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        # Default configuration. sandbox_home is only used as a fixed path inside the
        # bwrap namespace, isolated from the host; the host home is determined by
        # the runtime command line argument (see src/sandbox.nix).
        defaultConfig = {
          sandbox_home = "/home/napcat";
        };
      in
      rec {
        devShells.default = pkgs.mkShell { };
        lib.buildNapcat =
          module:
          pkgs.callPackage ./src {
            config = module;
          };
        packages.default = (lib.buildNapcat defaultConfig).script;
      }
    );
}
