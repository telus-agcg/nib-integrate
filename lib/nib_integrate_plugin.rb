require 'nib/integrate/version'
require 'nib/integrate/integrator'
require 'nib/integrate/config_file'
require 'nib/integrate/registrar'
require 'nib/integrate/lister'

module Nib
  # integrates multiple docker containers
  module Integrate
    def self.applies?
      true
    end
  end
end
