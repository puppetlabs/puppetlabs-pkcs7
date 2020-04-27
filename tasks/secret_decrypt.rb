# !/usr/bin/env ruby
# frozen_string_literal: true

require 'openssl'
require 'base64'

require_relative "../../ruby_task_helper/files/task_helper.rb"

class PKCS7Decrypt < TaskHelper
  def decrypt(opts)
    # Load public key
    public_key_path = File.expand_path(opts[:public_key], opts[:_boltdir])
    public_key      = OpenSSL::X509::Certificate.new(File.read(public_key_path))
    debug("Using public key: #{public_key_path}")

    # Load private key
    private_key_path = File.expand_path(opts[:private_key], opts[:_boltdir])
    private_key      = OpenSSL::PKey::RSA.new(File.read(private_key_path))
    debug("Using public key: #{public_key_path}")

    # Decode the ciphertext
    format = %r{\AENC\[PKCS7,(?<encoded>[\w\s+-=\\\/]+)\]\s*\z}
    match  = format.match(opts[:encrypted_value])

    unless match
      message = "Could not parse as an encrypted value: #{opts[:encrypted_value]}"
      raise TaskHelper::Error.new(message, 'pkcs7/parse-error', debug: debug_statements)
    end

    raw = Base64.decode64(match[:encoded])

    # Decrypt the ciphertext
    pkcs7 = OpenSSL::PKCS7.new(raw)
    pkcs7.decrypt(private_key, public_key)
  end

  def task(**opts)
    { value: decrypt(opts) }
  end
end

if $PROGRAM_NAME == __FILE__
  PKCS7Decrypt.run
end
