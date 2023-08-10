{ pkgs, ... } @ args:

let
  version = "0.14.0";
  cdn = "releases.commonfate.io";
  urls = {
    x86_64-linux = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_linux_x86_64.tar.gz";
      sha256 = "sha256-wHeh+BbeMtbJMEDZxOvihqcNpA4pR0s0Re0vhxcbq88=";
    };
    aarch64-linux = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_linux_arm64.tar.gz";
      sha256 = "";
    };
    x86_64-darwin = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_darwin_x86_64.tar.gz";
      sha256 = "sha256-kbnocFXZQbv0x8VroZkI/BH0LNgVf5zUc57Q5quejqU=";
    };
    aarch64-darwin = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_darwin_arm64.tar.gz";
      sha256 = "sha256-G24ika1dcGvigl6CmIo7YNFfFvJmxQp628BJFVsFEaI=";
    };
    x86_64-windows = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_windows_x86_64.zip";
      sha256 = "";
    };
    aarch64-windows = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_windows_arm64.zip";
      sha256 = "";
    };
  };
in pkgs.stdenv.mkDerivation {
  name = "granted.dev-${version}";

  src = pkgs.fetchurl urls.${pkgs.stdenv.system};

  setSourceRoot = "sourceRoot=`pwd`";

  dontStrip = true;

  # Windnows needs extra attention here I presume...
  installPhase = ''
    mkdir -p $out/bin

    for bin in granted assume assume.fish; do
      mv $bin $out/bin/
      chmod +x $out/bin/$bin
    done

    ln -s $out/bin/granted $out/bin/assumego
  '';

  meta = with pkgs.lib; {
    homepage = "https://www.granted.dev/";
    description = "A CLI application which provides the world’s best developer UX for finding and accessing cloud roles to multiple cloud accounts, fast!";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
