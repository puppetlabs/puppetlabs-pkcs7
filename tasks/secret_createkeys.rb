# !/usr/bin/env ruby
# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'fileutils'

require_relative "../../ruby_task_helper/files/task_helper.rb"

class PKCS7CreateKeys < TaskHelper
  def createkeys(opts)
    # Expand key paths
    public_key_path = File.expand_path(opts[:public_key], opts[:_boltdir])
    debug("Public key path: #{public_key_path}")

    private_key_path = File.expand_path(opts[:private_key], opts[:_boltdir])
    debug("Private key path: #{public_key_path}")

    # Check if a key pair already exists and fail if there is and 'force' is not set
    if (File.exist?(public_key_path) || File.exist?(private_key_path)) && !opts[:force]
      message = "Found existing key pair #{[public_key_path, private_key_path]}. Existing key "\
                "pairs can be overwritten by setting the 'force' option to true."
      raise TaskHelper::Error.new(message, 'bolt.plugin/key-error', debug: debug_statements)
    end

    key = OpenSSL::PKey::RSA.new(opts[:keysize])

    cert            = OpenSSL::X509::Certificate.new
    cert.subject    = OpenSSL::X509::Name.parse('/')
    cert.serial     = 1
    cert.version    = 2
    cert.not_before = Time.now
    cert.not_after  = Time.now + 50 * 365 * 24 * 60 * 60
    cert.public_key = key.public_key
    cert.sign(key, OpenSSL::Digest.new('SHA512'))

    debug("Overwriting private key: #{private_key_path}") if File.exist?(private_key_path)
    debug("Overwriting public key: #{public_key_path}") if File.exist?(public_key_path)

    private_keydir = File.dirname(private_key_path)
    FileUtils.mkdir_p(private_keydir) unless File.exist?(private_keydir)
    FileUtils.touch(private_key_path)
    File.chmod(0o600, private_key_path)
    File.write(private_key_path, key.to_pem)

    public_keydir = File.dirname(public_key_path)
    FileUtils.mkdir_p(public_keydir) unless File.exist?(public_keydir)
    File.write(public_key_path, cert.to_pem)

    [public_key_path, private_key_path]
  end

  def task(**opts)
    { value: createkeys(opts) }
  end
end

if $PROGRAM_NAME == __FILE__
  PKCS7CreateKeys.run
end
