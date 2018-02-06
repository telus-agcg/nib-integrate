require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Nib::Integrate::Registrar do
  subject { described_class }
  let(:default_config) { { 'apps' => [] } }
  let(:good_options) { { a: 'test1', p: './tmp/test', s: 'web' } }
  let(:config_file) { double(:config_file) }
  let(:path) { Nib::Integrate::ConfigFile::PATH }
  let(:new_app) do
    {
      'name' => 'test1',
      'path' => './tmp/test',
      'service' => 'web'
    }
  end
  let(:good_config) do
    { 'apps' => [new_app] }
  end

  before do
    allow_any_instance_of(subject)
      .to receive(:config_file).and_return(config_file)
    allow(config_file)
      .to receive(:read)
      .with(Nib::Integrate::ConfigFile::PATH)
      .and_return(default_config)
    allow(config_file)
      .to receive(:write)
      .with(good_config, Nib::Integrate::ConfigFile::PATH)
      .and_return(true)
  end

  it 'has a call method' do
    expect(Nib::Integrate::Registrar).to respond_to :call
  end

  it 'takes options and config path in the call method' do
    expect(Nib::Integrate::Registrar.method(:call).arity).to eq(-2)
  end

  it 'will error if no -a parameter is given' do
    bad_options = good_options.reject { |o| o == :a || o == 'a' }
    expect { Nib::Integrate::Registrar.call(bad_options) }
      .to raise_error(/No app name given/)
  end

  it 'will error if no path is given' do
    bad_options = good_options.reject { |o| o == :p || o == 'p' }
    expect { Nib::Integrate::Registrar.call(bad_options) }
      .to raise_error(/No path given/)
  end

  it 'will write the new config if the options are valid' do
    expect(config_file).to receive(:write).with(good_config, path)
    Nib::Integrate::Registrar.call(good_options)
  end
end
# rubocop:enable Metrics/BlockLength
