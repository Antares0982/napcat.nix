{
  nixpkgs ? <nixpkgs>,
}:
let
  check =
    system: hash:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      changed = pkgs // {
        qq = pkgs.qq.overrideAttrs (_: {
          version = "9999";
          src = throw "QQ must use its pinned source";
        });
      };
      napcat = changed.callPackage ../src/napcat.nix {
        pkgs = changed;
        sandbox_home = "/home/napcat";
      };
    in
    assert napcat.patched.version == "3.2.34-2026-09-24-v4.18.42";
    assert napcat.patched.src.outputHash == hash;
    true;
in
assert check "aarch64-linux" "sha256-GBuJXLVzVI45blS7BUjMqS/9wbGksBj6RVG7BiOF/co=";
assert check "x86_64-linux" "sha256-Q2xl4d0oQi4SiiHL3bX+Ti5sB51/J/7CVB4BTTjMM24=";
true
