#!/usr/bin/env ruby

# This is a super hacky script to fetch the latest ISOs and their sha256sums.
# Who says you can't parse HTML with regexes? Bah!

require 'open-uri'
require 'shellwords'
require 'json'

def fetch(url)
  open(url) {|f| f.read }
end

def sha256(path)
  `shasum -a256 "#{path}" | cut -d' ' -f1`.chomp
end

def sha256url(url)
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      system "wget #{url.shellescape}"
      path = Dir.glob("*").first
      hash = sha256(path)

      hash
    end
  end
end

ISOS = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

# get stable urls
page = fetch("http://releases.nixos.org/nixos/14.04/")
url = page.scan(/<a href="(nixos-14.04[^"]+\/)"/).flatten.last
page = fetch("http://releases.nixos.org/nixos/14.04/#{url}")
iso_name = page.scan(/<a href="(nixos-minimal-[^"]+-x86_64-linux.iso)"/).flatten.first
ISOS["nixos-14.04-x86_64"]["url"] = "http://releases.nixos.org/nixos/14.04/#{url}#{iso_name}"
ISOS["nixos-14.04-x86_64"]["channel"] = "https://nixos.org/channels/nixos-14.04"
iso_name = page.scan(/<a href="(nixos-minimal-[^"]+-i686-linux.iso)"/).flatten.first
ISOS["nixos-14.04-i686"]["url"] = "http://releases.nixos.org/nixos/14.04/#{url}#{iso_name}"
ISOS["nixos-14.04-i686"]["channel"] = "https://nixos.org/channels/nixos-14.04"

# get unstable urls
page = fetch("http://releases.nixos.org/nixos/unstable/")
url = page.scan(/<a href="(nixos-14.10[^"]+\/)"/).flatten.last
page = fetch("http://releases.nixos.org/nixos/unstable/#{url}")
iso_name = page.scan(/<a href="(nixos-minimal-[^"]+-x86_64-linux.iso)"/).flatten.first
ISOS["nixos-14.10-x86_64"]["url"] = "http://releases.nixos.org/nixos/unstable/#{url}#{iso_name}"
ISOS["nixos-14.10-x86_64"]["channel"] = "https://nixos.org/channels/nixos-unstable"
iso_name = page.scan(/<a href="(nixos-minimal-[^"]+-i686-linux.iso)"/).flatten.first
ISOS["nixos-14.10-i686"]["url"] = "http://releases.nixos.org/nixos/unstable/#{url}#{iso_name}"
ISOS["nixos-14.10-i686"]["channel"] = "https://nixos.org/channels/nixos-unstable"

# set guest_os_type
ISOS.each do |k,v|
  v["guest_os_type"] =
    if v["url"] =~ /x86_64/
      "Linux_64"
    else
      "Linux"
    end
end

# get sha256
ISOS.each do |k,v|
  v["sha256"] = sha256url(v["url"])
end

# dump the json
File.open("isos.json", "w") do |f|
  json = JSON.pretty_generate(ISOS)
  f.write(json)
end
