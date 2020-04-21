# frozen_string_literal: true

require 'spec_helper'
require_relative '../../tasks/secret_encrypt.rb'

describe PKCS7Encrypt do
  let(:boltdir)         { File.expand_path(__dir__) }
  let(:public_key)      { File.expand_path('../fixtures/keys/public_key.pkcs7.pem', boltdir) }

  let(:opts) do
    {
      _boltdir:        boltdir,
      plaintext_value: 'hello world',
      public_key:      public_key
    }
  end

  it 'encrypts a value' do
    expect(subject.task(opts)[:value]).to start_with('ENC[PKCS7,')
  end

  it 'returns an error if one is raised' do
    error = TaskHelper::Error.new('something went wrong', 'bolt.test/error')
    allow(subject).to receive(:encrypt).and_raise(error)
    expect { subject.task({}) }.to raise_error(TaskHelper::Error, /something went wrong/)
  end
end
