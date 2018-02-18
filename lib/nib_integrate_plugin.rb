require 'ostruct'
require 'nib/integrate/config_file'
require 'nib/integrate/integration_file'
require 'nib/integrate/integration_file_config'
require 'nib/integrate/integrator'
require 'nib/integrate/network_creator'
require 'nib/integrate/lister'
require 'nib/integrate/registrar'
require 'nib/integrate/version'

module Nib
  # integrates multiple docker containers
  module Integrate
    def self.applies?
      true
    end
  end
end
