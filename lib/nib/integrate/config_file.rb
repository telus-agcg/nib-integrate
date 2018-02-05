require 'yaml'

module Nib
  # plugin module
  module Integrate
    # reads and writes the config file
    class ConfigFile
      PATH = '~/.nib-integrate-config'.freeze
      DEFAULT_CONFIG = { apps: [] }.freeze
      class << self
        def write(config)
          # this will write the config file.
          File.open(PATH, 'w') do |f|
            f.write(config.to_yaml)
          end
        end

        def read
          YAML.load_file(PATH)
        end
      end
    end
  end
end
