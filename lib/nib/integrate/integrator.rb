module Nib
  module Integrate
    # performs docker-compose integration
    class Integrator
      class << self
        def call(args)
          new(args)._call
        end
      end

      attr_reader :args, :current_arg

      def initialize(args)
        @args = args
      end

      def _call
        args.each do |arg|
          @current_arg = arg
          system command
        end
      end

      def command
        "#{cd_command} && #{docker_compose_command}"
      end

      def cd_command
        "cd ../#{current_arg}"
      end

      def docker_compose_command
        <<-CMD
        docker-compose run --rm -it web \
          -f docker-compose.yml \
          -f docker-compose-integration.yml
        CMD
      end
    end
  end
end
