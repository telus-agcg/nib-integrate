require 'yaml'

module Nib
  # plugin module
  module Integrate
    # reads and writes the config file
    class ConfigFile
      PATH = "#{ENV['HOME']}/.nib-integrate-config".freeze
      DEFAULT_CONFIG = { 'apps' => [], 'initial_port' => 10_000 }.freeze
      class << self
        def write(config, path = PATH)
          # this will write the config file.
          File.open(path, 'w') do |f|
            f.write(config.to_yaml)
          end
        end

        def read(path = PATH)
          YAML.load_file(path)
        end
      end
    end
  end
end
