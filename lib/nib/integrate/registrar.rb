module Nib
  module Integrate
    # registers applications for integration
    class Registrar
      class << self
        def call(options, config_path = ConfigFile::PATH)
          new(options, config_path).call
        end
      end

      attr_reader :options, :config_path

      def initialize(options, config_path)
        @options = options
        @config_path = config_path
      end

      def call
        return unless valid?
        return if app_config_exists?
        register_app
        true
      end

      private

      def valid?
        raise 'No app name given' unless options[:a]
        raise 'No path given' unless options[:p]
        raise 'No service name given' unless options[:s]
        true
      end

      def app_config_exists?
        existing_config['apps']
          .select { |app| app['name'] == app_name }
          .size
          .positive?
      end

      def register_app
        existing_config['apps'] << new_app
        config_file.write(existing_config, config_path)
      end

      def new_app
        {
          'name' => options[:a],
          'path' => options[:p],
          'service' => options[:s],
          'compose_file' => options[:d],
          'integration_compose_file' => options[:i]
        }.compact
      end

      def existing_config
        @existing_config ||= config_file.read(config_path)
      end

      def app_name
        options[:a]
      end

      def config_file
        ConfigFile
      end
    end
  end
end
