require 'nib/integrate/version'
require 'nib/integrate/integrator'

module Nib
  # integrates multiple docker containers
  module Integrate
    def self.applies?
      true
    end
  end
end
