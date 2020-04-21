# frozen_string_literal: true

require 'spec_helper'
require_relative '../../tasks/secret_decrypt.rb'

describe PKCS7Decrypt do
  let(:boltdir)         { File.expand_path(__dir__) }
  let(:encrypted_value) { File.read(File.expand_path('../fixtures/output/encrypted_value.txt', boltdir)) }
  let(:private_key)     { File.expand_path('../fixtures/keys/private_key.pkcs7.pem', boltdir) }
  let(:public_key)      { File.expand_path('../fixtures/keys/public_key.pkcs7.pem', boltdir) }

  it 'decrypts a value' do
    result = subject.task(
      _boltdir:        boltdir,
      encrypted_value: encrypted_value,
      private_key:     private_key,
      public_key:      public_key
    )

    expect(result[:value]).to eq('hello world')
  end

  it 'returns an error if one is raised' do
    error = TaskHelper::Error.new('something went wrong', 'bolt.test/error')
    allow(subject).to receive(:decrypt).and_raise(error)
    expect { subject.task({}) }.to raise_error(TaskHelper::Error, /something went wrong/)
  end
end
