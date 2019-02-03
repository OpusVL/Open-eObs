require "serverspec"
require "serverspec_extended_types"
require "docker"

def image
  version = ENV['VERSION']
  "open-eobs-odoo:#{version}"
end
