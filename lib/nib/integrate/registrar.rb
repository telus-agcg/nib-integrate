module Nib
  module Integrate
    # registers applications for integration
    class Registrar
      class << self
        def call(options)
          puts options.inspect
        end
      end
    end
  end
end
