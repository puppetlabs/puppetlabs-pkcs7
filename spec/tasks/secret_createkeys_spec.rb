# frozen_string_literal: true

require 'tmpdir'
require 'spec_helper'
require_relative '../../tasks/secret_createkeys.rb'

describe PKCS7CreateKeys do
  let(:boltdir)     { Dir.mktmpdir(nil, __dir__) }
  let(:private_key) { File.expand_path('keys/private_key.pkcs7.pem', @boltdir) }
  let(:public_key)  { File.expand_path('keys/public_key.pkcs7.pem', @boltdir) }

  let(:opts) do
    {
      _boltdir:    @boltdir,
      keysize:     1024,
      private_key: private_key,
      public_key:  public_key
    }
  end

  around(:each) do |example|
    Dir.mktmpdir do |dir|
      @boltdir = dir
      example.run
    end
  end

  it 'creates keys' do
    result = subject.task(opts)

    expect(result[:value]).to match_array([public_key, private_key])
    expect(File.exist?(private_key)).to be(true)
    expect(File.exist?(public_key)).to be(true)
    expect(File.stat(private_key).mode.to_s(8)[3..-1]).to eq('600')
  end

  it 'errors when attempting to overwrite keys' do
    subject.task(opts)
    expect { subject.task(opts) }.to raise_error(TaskHelper::Error, /Found existing key pair/)
  end

  it 'overwrites keys with force set' do
    subject.task(opts)
    original_private_key = File.read(private_key)
    original_public_key  = File.read(public_key)

    opts[:force] = true
    result = subject.task(opts)

    expect(result[:value]).to match_array([public_key, private_key])
    expect(File.read(private_key)).not_to eq(original_private_key)
    expect(File.read(public_key)).not_to eq(original_public_key)
  end

  it 'returns an error if one is raised' do
    error = TaskHelper::Error.new('something went wrong', 'bolt.test/error')
    allow(subject).to receive(:createkeys).and_raise(error)

    expect { subject.task({}) }.to raise_error(TaskHelper::Error, /something went wrong/)
  end
end
