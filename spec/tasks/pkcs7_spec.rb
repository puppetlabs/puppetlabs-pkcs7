# frozen_string_literal: true

require 'tmpdir'

require_relative '../../tasks/secret_encrypt.rb'
require_relative '../../tasks/secret_decrypt.rb'
require_relative '../../tasks/secret_createkeys.rb'

describe 'pkcs7 plugin' do
  let(:private_key) { File.expand_path('keys/private_key.pkcs7.pem', @boltdir) }
  let(:public_key)  { File.expand_path('keys/public_key.pkcs7.pem', @boltdir) }
  let(:message)     { 'hello world' }

  around(:each) do |example|
    Dir.mktmpdir do |dir|
      @boltdir = dir
      example.run
    end
  end

  it 'has reversible encryption' do
    PKCS7CreateKeys.new.task(
      _boltdir:    @boltdir,
      keysize:     1024,
      private_key: private_key,
      public_key:  public_key
    )

    ciphertext = PKCS7Encrypt.new.task(
      _boltdir:        @boltdir,
      plaintext_value: message,
      public_key:      public_key
    )

    expect(ciphertext[:value]).to start_with('ENC[PKCS7,')

    plaintext = PKCS7Decrypt.new.task(
      _boltdir:        @boltdir,
      encrypted_value: ciphertext[:value],
      private_key:     private_key,
      public_key:      public_key
    )

    expect(plaintext[:value]).to eq(message)
  end
end
