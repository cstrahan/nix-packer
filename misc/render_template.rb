#!/usr/bin/env ruby

# Renders the packer-template.json,
# using the values in isos.json.

require 'json'

ISOS     = JSON.parse(File.open("isos.json", &:read)).freeze
TEMPLATE = File.open("packer-template.json", &:read).freeze

ISOS.each do |name, attrs|
  template = TEMPLATE.dup
  template.gsub!("@VM_NAME@",       name)
  template.gsub!("@ISO_URL@",       attrs["url"])
  template.gsub!("@ISO_CHECKSUM@",  attrs["sha256"])
  template.gsub!("@GUEST_OS_TYPE@", attrs["guest_os_type"])

  File.open("#{name}.json", "w") do |f|
    f.write(template)
  end
end
