require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Nib::Integrate::Integrator do
  subject { described_class }
  let(:app_args) { %w[foo bar] }
  let(:config) do
    {
      'apps' => [
        {
          'name' => 'foo',
          'path' => '/foo/path',
          'service' => 'web',
          'compose_file' => 'docker-compose.yml'
        },
        {
          'name' => 'bar',
          'path' => '/bar/path',
          'service' => 'worker',
          'compose_file' => 'd-c-web.yml',
          'integration_file' => 'int.yml'
        }
      ]
    }
  end
  let(:config_file) { double(:config_file) }
  # rubocop:disable Metrics/LineLength
  let(:command_strings) do
    [
      'cd /foo/path && docker-compose -f docker-compose.yml -f foo.yml up -d web',
      'cd /bar/path && docker-compose -f d-c-web.yml -f foo.yml up -d worker'
    ]
  end
  # rubocop:enable Metrics/LineLength

  let(:down_command_strings) do
    [
      'cd /foo/path && docker-compose -f docker-compose.yml stop',
      'cd /bar/path && docker-compose -f d-c-web.yml stop'
    ]
  end

  before do
    allow_any_instance_of(subject)
      .to receive(:config_file).and_return(config_file)
    allow(config_file).to receive(:read).and_return(config)
    allow_any_instance_of(subject)
      .to receive(:integration_file_path).and_return('foo.yml')
  end

  it 'has an up method' do
    expect(subject).to respond_to(:up)
  end

  it 'returns an array of command strings when upped' do
    expect(subject.up(app_args)).to eq command_strings
  end

  it 'returns an array of command strings when downed' do
    expect(subject.down(app_args)).to eq down_command_strings
  end
end
# rubocop:enable Metrics/BlockLength
