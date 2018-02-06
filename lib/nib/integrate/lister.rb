module Nib
  module Integrate
    # lists registered applications
    class Lister
      class << self
        def call(config_path = ConfigFile::PATH)
          apps(config_path).map { |app| app['name'] }
        end

        def config_file
          ConfigFile
        end

        def apps(config_path)
          config_file.read(config_path)['apps']
        end
      end
    end
  end
end
