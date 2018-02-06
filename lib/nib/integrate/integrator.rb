module Nib
  module Integrate
    # performs docker-compose integration
    class Integrator
      class << self
        def up(args, config_path = Nib::Integrate::ConfigFile::PATH)
          new(args, config_path).up
        end

        def down(args, config_path = Nib::Integrate::ConfigFile::PATH)
          new(args, config_path).down
        end
      end

      attr_reader :args, :current_arg, :config_path

      def initialize(args, config_path)
        @args = args
        @config_path = config_path
      end

      def up
        args.map do |arg|
          @current_arg = arg
          command
        end
      end

      def down
        args.map do |arg|
          @current_arg = arg
          down_command
        end
      end

      private

      def app
        apps.find { |a| a['name'] == current_arg }
      end

      def apps
        @apps ||= config_file.read(config_path)['apps']
      end

      def command
        [cd_command, docker_compose_command].join(' && ')
      end

      def down_command
        [
          cd_command,
          "docker-compose -f #{app['compose_file']} stop"
        ].join(' && ')
      end

      def cd_command
        "cd #{app['path']}"
      end

      def docker_compose_command
        [run_command, integration_file_flag, up_command].compact.join(' ')
      end

      def run_command
        "docker-compose -f #{app['compose_file']}"
      end

      def up_command
        "up -d #{app['service']}"
      end

      def integration_file_flag
        return unless app['integration_file'] && !app['integration_file'].empty?
        "-f #{app['integration_file']}"
      end

      def config_file
        ConfigFile
      end
    end
  end
end
