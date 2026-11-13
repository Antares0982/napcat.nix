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
  patched = (pkgs.qq.override { disableAutoUpdate = true; }).overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.unzip ]; # Add unzip to build dependencies
    version = "${sources.qq_version}-${sources.napcat_version}";
    src = pkgs.fetchurl sources.qq_sources.${pkgs.stdenv.hostPlatform.system};
    __intentionallyOverridingVersion = true;
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
