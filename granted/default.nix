{ pkgs, ... } @ args:

let
  version = "0.14.2";
  cdn = "releases.commonfate.io";
  urls = {
    x86_64-linux = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_linux_x86_64.tar.gz";
      sha256 = "sha256-tNg1shC+qcxpjRbuDRCbJ7CePFfQns8lyn5xEZHv1h4==";
    };
    aarch64-linux = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_linux_arm64.tar.gz";
      sha256 = "sha256-ZA8GHmtid4qUHn09FOmKTj1+ynrFN01IMJq+6ETlMCI=";
    };
    x86_64-darwin = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_darwin_x86_64.tar.gz";
      sha256 = "sha256-YmNAA6TMafwIzvpVzvwMGEshvlzLAYhPbWWlQ+i48cY=";
    };
    aarch64-darwin = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_darwin_arm64.tar.gz";
      sha256 = "sha256-7EY3MEnaTPUrz2Dk+RmICol8qeIpqe6bBBBCXG2fTQA==";
    };
    x86_64-windows = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_windows_x86_64.zip";
      sha256 = "sha256-BvDX+tAw8hvexdxwk5Nb+0hPP5f7UZKZeN/PlXLCdFQ=";
    };
    aarch64-windows = {
      url = "https://${cdn}/granted/v${version}/granted_${version}_windows_arm64.zip";
      sha256 = "sha256-9otJNz3XyuSGOwt9xOUWIqxSlfReE9WdfHcGKApyato=";
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
