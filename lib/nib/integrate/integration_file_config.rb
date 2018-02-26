# frozen_string_literal: true

module Nib
  module Integrate
    # IntegrationFileConfig creates a proper configuration yaml string
    # and keeps track of port assignments
    class IntegrationFileConfig
      attr_reader :app_name, :current_port
      def initialize(app_name, current_port)
        @app_name = app_name
        @current_port = current_port
      end

      def config
        OpenStruct.new(
          config: config_hash,
          path: path,
          port: current_port
        )
      end

      def empty_config
        OpenStruct.new(
          config: { 'version' => app_compose_contents['version'] },
          path: empty_path
        )
      end

      private

      def config_hash
        app_services.each_with_object(merged_config) do |elem, acc|
          service_definition = {
            'external_links' =>  external_links,
            'networks' => %w[default nib]
          }
          service_definition['ports'] = ports(elem) if ports(elem)

          acc['services'][elem].merge!(service_definition)
        end
      end

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
        "#{app['path']}/.nib-integrate-network-config"
      end

      def empty_path
        "#{app['path']}/.nib-integrate-empty-config-file"
      end

      def merged_config
        app_compose_contents.merge(network_config)
      end

      def ports(service_definition)
        ports = app_docker_compose['services'][service_definition]['ports']
        return unless ports && !ports.empty?
        ports.map do |port|
          existing_ports = port.split(':')
          [next_port, existing_ports[1]].join(':')
        end
      end

      def next_port
        @current_port += 1
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
