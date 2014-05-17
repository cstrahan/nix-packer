# TODO: remove once updated in 14.04 stable.
# The Debian maintainers removed the download for version 5.1.1,
# breaking nixos-install.
# https://github.com/NixOS/nixpkgs/pull/2653
{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "mkpasswd-${version}";

  version = "5.1.1";

  src = fetchgit {
    url = https://github.com/rfc1036/whois.git;
    rev = "refs/tags/v${version}";
    sha256 = "1546vz05kzi93y9ii2yi6aqdzsprj8c1w9a2gjpkigxxxxzhxi4y";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "prefix = /usr" "prefix = $out"
  '';

  buildPhase = "make mkpasswd";

  installPhase = "make install-mkpasswd";

  meta = {
    homepage = http://ftp.debian.org/debian/pool/main/w/whois/;
    description = ''
      Overfeatured front end to crypt, from the Debian whois package.
    '';
  };
}
