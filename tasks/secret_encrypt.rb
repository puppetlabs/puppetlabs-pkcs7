# !/usr/bin/env ruby
# frozen_string_literal: true

require 'openssl'
require 'base64'

require_relative "../../ruby_task_helper/files/task_helper.rb"

class PKCS7Encrypt < TaskHelper
  def encrypt(opts)
    # Load public key
    public_key_path = File.expand_path(opts[:public_key], opts[:_boltdir])
    public_key      = OpenSSL::X509::Certificate.new(File.read(public_key_path))
    debug("Using public key: #{public_key_path}")

    # Initialize the cipher
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)

    # Encrypt plaintext
    raw = OpenSSL::PKCS7.encrypt([public_key], opts[:plaintext_value], cipher, OpenSSL::PKCS7::BINARY).to_der

    # Encode the raw ciphertext
    "ENC[PKCS7,#{Base64.encode64(raw).strip}]"
  end

  def task(**opts)
    { value: encrypt(opts) }
  end
end

if $PROGRAM_NAME == __FILE__
  PKCS7Encrypt.run
end
