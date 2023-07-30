{ pkgs, ... } @ args:

with
  (import <nixpkgs> { });

let
  version = "0.14.0";
  systemAttr = builtins.listToAttrs (
    lib.lists.zipListsWith
      (l: r: { name = l; value = r; })
      ["arch" "kernel"]
      (lib.strings.splitString "-" pkgs.stdenv.system)
  );
  kernel = systemAttr.kernel;
  arch = systemAttr.arch;
in stdenv.mkDerivation {
  name = "granted.dev-${version}";

  src = pkgs.fetchurl {
    url = "https://releases.commonfate.io/granted/v${version}/granted_${version}_${kernel}_${arch}.tar.gz";
    sha256 = "sha256-kbnocFXZQbv0x8VroZkI/BH0LNgVf5zUc57Q5quejqU=";
  };

  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    mkdir -p $out/bin

    for bin in granted assume assume.fish; do
      cp $bin $out/bin/
      chmod +x $out/bin/$bin
    done

    ln -s $out/bin/granted $out/bin/assumego
  '';

  meta = with lib; {
    homepage = "https://www.granted.dev/";
    description = "A CLI application which provides the world’s best developer UX for finding and accessing cloud roles to multiple cloud accounts, fast!";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
