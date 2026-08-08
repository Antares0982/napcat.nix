{
  pkgs,
  lib,
  sandbox_home,
  ...
}:
let
  sources = pkgs.callPackage ./sources.nix { };
  napcat-shell-zip = pkgs.fetchurl {
    url = sources.napcat_url;
    hash = sources.napcat_hash;
  };
in
rec {
  # QQ itself comes straight from nixpkgs: Tencent deletes old builds from its
  # CDN within weeks, so any URL we pin here 404s on the next flake update.
  patched = pkgs.qq.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.unzip ]; # Add unzip to build dependencies
    version = "${old.version}-${sources.napcat_version}";
    __intentionallyOverridingVersion = true; # version tag only, src stays nixpkgs'
    postFixup = ''
      mkdir -p $out/napcat
      unzip ${napcat-shell-zip} -d $out/napcat
      echo "(async () => {await import('${sandbox_home}/napcat/napcat.mjs');})();" > $out/opt/QQ/resources/app/loadNapCat.js
      sed -i 's|"main": "[^"]*"|"main": "./loadNapCat.js"|' $out/opt/QQ/resources/app/package.json
    '';
    meta = {
      description = "Modern protocol-side framework based on NTQQ";
      homepage = "https://github.com/NapNeko/NapCatQQ";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  });
  program = "${patched}/bin/qq --no-sandbox";
}
