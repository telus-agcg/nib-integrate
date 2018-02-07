module Nib
  module Integrate
    # dynamically generated network config file
    class IntegrationFile
      class << self
        def write(app_name)
          new(app_name).write
        end
      end

      attr_reader :app_name

      def initialize(app_name)
        @app_name = app_name
      end

      def write
        File.open(path, 'w') do |f|
          f.write(config.to_yaml)
        end
        path
      end

      private

      def apps
        @apps ||= global_config['apps']
      end

      def app
        apps.find { |a| a['name'] == app_name }
      end

      def other_apps
        apps.reject { |a| a['name'] == app_name }
      end

      def path
        "#{ENV['HOME']}/.nib-integrate-network-config-#{app['name']}"
      end

      def config
        app_services.each_with_object(network_config) do |elem, acc|
          acc['services'] = {
            elem => {
              'external_links' =>  external_links,
              'networks' => %w[default nib]
            }
          }
        end
      end

      def external_links
        other_apps.map(&external_link)
      end

      def external_link
        lambda do |registration|
          "#{container_name(registration)}_1:#{container_name(registration)}"
        end
      end

      def container_name(registration)
        project_name = registration['path'].split('/').last.gsub(/[ _]/, '')
        service_name = registration['service']
        "#{project_name}_#{service_name}"
      end

      def network_config
        {
          'version' => '2',
          'services' => {},
          'networks' => {
            'nib' => { 'external' => { 'name' => 'nib-integrate-network' } }
          }
        }
      end

      def app_docker_compose
        @app_docker_compose ||= app_compose_contents
      end

      def app_compose_contents
        YAML.load_file("#{app['path']}/#{app['compose_file']}")
      end

      def app_services
        app_docker_compose['services'].keys
      end

      def global_config
        ConfigFile.read
      end
    end
  end
end
