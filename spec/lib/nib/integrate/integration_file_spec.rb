require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Nib::Integrate::IntegrationFile do
  subject { described_class }
  let(:instance) { subject.new(app_name) }
  let(:current_port) { 10_000 }
  let(:app_name) { 'foo' }
  let(:app_path) { 'spec/support/foo_app/.nib-integrate-network-config' }
  let(:config) do
    {
      'apps' => [
        {
          'name' => 'foo',
          'path' => 'spec/support/foo_app',
          'service' => 'web',
          'compose_file' => 'docker-compose.yml'
        },
        {
          'name' => 'bar',
          'path' => 'spec/support/bar_app',
          'service' => 'api',
          'compose_file' => 'docker-compose.yml'
        }
      ]
    }
  end
  let(:app_config) do
    {
      'version' => '2',
      'services' => {
        'web' => {
          'volumes' => [],
          'ports' => ['3000:3000']
        },
        'other' => {
          'volumes' => [],
          'ports' => ['3000:3000']
        }
      }
    }
  end
  let(:integration_config) do
    {
      'version' => '2',
      'services' => {
        'web' => {
          'volumes' => [],
          'ports' => ['10002:3000'],
          'external_links' => ['barapp_api_1:barapp_api'],
          'networks' => %w[default nib]
        },
        'other' => {
          'volumes' => [],
          'ports' => ['10004:3000'],
          'external_links' => ['barapp_api_1:barapp_api'],
          'networks' => %w[default nib]
        }
      },
      'networks' => {
        'nib' => {
          'external' => {
            'name' => 'nib-integrate-network'
          }
        }
      }
    }
  end
  let(:integration_file_config) do
    Nib::Integrate::IntegrationFileConfig.new(app_name, current_port)
  end

  before do
    allow(instance).to receive(:integration_file_config).and_return(integration_file_config)
    allow(integration_file_config).to receive(:global_config).and_return(config)
    allow(integration_file_config).to receive(:app_compose_contents).and_return(app_config)
  end
  it 'produces a flie with a network configuration given an app name' do
    config = instance.write
    expect(config.path).to eq app_path
  end

  it 'produces a flie with a network configuration' do
    config = instance.write
    expect(YAML.load_file(config.path)).to eq integration_config
  end
end
# rubocop:enable Metrics/BlockLength
