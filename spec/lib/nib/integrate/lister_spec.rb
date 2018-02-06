require 'spec_helper'

RSpec.describe Nib::Integrate::Lister do
  subject { described_class }
  let(:config) { { 'apps' => [{ 'name' => 'name', 'path' => 'path' }] } }
  let(:names) { %w[name] }

  before do
    allow(subject).to receive(:apps).and_return(config['apps'])
  end

  it 'has a call method' do
    expect(subject).to respond_to(:call)
  end

  it 'returns an array of registered apps' do
    result = subject.call
    expect(result).to eq names
  end
end
