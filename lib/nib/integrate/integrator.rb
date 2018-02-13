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

      attr_reader :args, :current_arg, :config_path, :current_port

      def initialize(args, config_path)
        @args = args
        @config_path = config_path
        @current_port = initial_port
      end

      def up
        args.map do |arg|
          @current_arg = arg
          @current_port += 1
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
        @apps ||= config['apps']
      end

      def initial_port
        @initial_port ||= config['initial_port']
      end

      def command
        integration_file.write_empty_config(app['name'])
        [
          cd_command,
          docker_compose_command,
          clean_files_command
        ].join(' && ')
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

      def clean_files_command
        'rm .nib-integrate*'
      end

      def run_command
        'docker-compose -f .nib-integrate-empty-config-file'
      end

      def up_command
        "up -d #{app['service']}"
      end

      def integration_file_flag
        "-f #{integration_file_path}"
      end

      def integration_file_path
        integration_file.write(app['name'], current_port)
      end

      def config
        @config ||= config_file.read(config_path)
      end

      def config_file
        ConfigFile
      end

      def integration_file
        IntegrationFile
      end
    end
  end
end
