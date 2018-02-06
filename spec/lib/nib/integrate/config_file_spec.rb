require 'spec_helper'

RSpec.describe Nib::Integrate::ConfigFile do
  let(:default_config) { { 'apps' => [] } }
  let(:empty_config) { { 'apps' => [] } }
  let(:test_path) { '.nib-integrate-config-test-path' }
  let(:default_path) { "#{ENV['HOME']}/.nib-integrate-config" }
  it 'has an expected path for the config file' do
    expect(Nib::Integrate::ConfigFile::PATH).to eq default_path
  end

  it 'has a default empty configuration' do
    expect(Nib::Integrate::ConfigFile::DEFAULT_CONFIG).to eq('apps' => [])
  end

  it 'is able to write a configuration to the file' do
    Nib::Integrate::ConfigFile.write(default_config, test_path)
    expect(File.exist?(test_path)).to be true
  end

  it 'is able to read a configuration file into a hash' do
    Nib::Integrate::ConfigFile.write(empty_config)
    result = Nib::Integrate::ConfigFile.read(test_path)
    expect(result).to eq default_config
  end
end
