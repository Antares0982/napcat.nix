{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config;
  napcat = pkgs.callPackage ./napcat.nix { inherit (cfg) sandbox_home; };
  fonts = pkgs.makeFontsConf {
    fontDirectories = with pkgs; [ source-han-sans ];
  };
in
{
  script = pkgs.writeScriptBin "NapCat" ''
    #!${pkgs.runtimeShell}
    # 第一个命令行参数指定宿主机 home 路径,缺省 fallback 到 /home/antares;
    # 其余参数继续透传给 napcat。沙箱内部路径与宿主机隔离,保持 build-time 固定。
    HOST_HOME="''${1:-/home/antares}"
    [ $# -gt 0 ] && shift
    QQ_CONFIG_DIR="$HOST_HOME/napcat/config"
    NC_CONFIG_DIR="$HOST_HOME/.config/QQ"
    mkdir -p "$QQ_CONFIG_DIR" "$NC_CONFIG_DIR"
    ${pkgs.bubblewrap}/bin/bwrap \
      --unshare-all \
      --share-net \
      --as-pid-1 \
      --uid 0 --gid 0 \
      --clearenv \
      --ro-bind /nix/store /nix/store \
      --ro-bind ${pkgs.tzdata}/share/zoneinfo/Asia/Shanghai /etc/localtime \
      --bind "$NC_CONFIG_DIR" ${cfg.sandbox_home}/napcat/config \
      --bind "$QQ_CONFIG_DIR" ${cfg.sandbox_home}/.config/QQ \
      --proc /proc \
      --dev /dev \
      --tmpfs /tmp \
      ${pkgs.writeScript "sandbox" ''
        #!${pkgs.runtimeShell}

        createService() {
          mkdir -p /services/$1
          echo -e "#!${pkgs.runtimeShell}\n$2" > /services/$1/run
          chmod +x /services/$1/run
        }

        export PATH=${
          lib.makeBinPath (
            with pkgs;
            [
              busybox
              xorg.xorgserver
            ]
          )
        }
        export HOME=${cfg.sandbox_home}
        export XDG_DATA_HOME=${cfg.sandbox_home}/.local/share
        export XDG_CONFIG_HOME=${cfg.sandbox_home}/.config
        export TERM=xterm
        mkdir -p /usr/bin /bin
        ln -s $(which env) /usr/bin/env
        ln -s $(which sh) /bin/sh

        export DISPLAY=':114'
        createService xvfb 'Xvfb :114 > /dev/null 2>&1'
        cp -rf ${napcat.patched}/napcat/* ${cfg.sandbox_home}/napcat/
        createService program "${napcat.program} $@"
        runsvdir /services
      ''} "$@"
  '';
}
