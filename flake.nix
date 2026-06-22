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
        # 默认配置。sandbox_home 仅用于 bwrap namespace 内部的固定路径,
        # 与宿主机隔离;宿主机 home 由运行时命令行参数决定(见 src/sandbox.nix)。
        defaultConfig = {
          sandbox_home = "/home/antares";
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
