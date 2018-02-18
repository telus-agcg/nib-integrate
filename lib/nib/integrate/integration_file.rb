# frozen_string_literal: true

module Nib
  module Integrate
    # dynamically generated network config file
    class IntegrationFile
      class << self
        def write(app_name, port = 10_000)
          new(app_name, port).write
        end

        def write_empty_config(app_name, port = 10_000)
          new(app_name, port).write_empty_config
        end
      end

      attr_reader :app_name, :current_port

      def initialize(app_name, port = 10_000)
        @current_port = port
        @app_name = app_name
      end

      def write
        config.tap do |cfg|
          File.open(cfg.path, 'w') do |f|
            f.write(cfg.config.to_yaml)
          end
        end
      end

      def write_empty_config
        empty_config.tap do |cfg|
          File.open(cfg.path, 'w') do |f|
            f.write(cfg.config.to_yaml)
          end
        end
      end

      private

      def config
        integration_file_config.config
      end

      def empty_config
        integration_file_config.empty_config
      end

      def integration_file_config
        IntegrationFileConfig.new(app_name, current_port)
      end
    end
  end
end
