# pkcs7

#### Table of Contents

1. [Description](#description)
1. [Parameters](#parameters)
1. [Configuration](#configuration)
1. [Usage](#usage)
1. [Bolt CLI Usage](#bolt-cli-usage)

## Description

This module includes Bolt plugins for creating key pairs and encrypting and decrypting sensitive values.

## Parameters

### `pkcs7::secret_createkeys`

The `pkcs7::secret_createkeys` task creates a key pair used to encrypt and decrypt values. It accepts the following values:

| Option | Type | Description | Default |
| ------ | ---- | ----------- | ------- |
| `force` | `Boolean` | Whether to overwrite an existing key pair. | `false` |
| `keysize` | `Integer` | The size of the key to generate. | `2048` |
| `private_key` | `String` | The path to the private key. Accepts an absolute path or a path relative to the `boltdir`. | `<boltdir>/keys/private_key.pkcs7.pem` |
| `public_key` | `String` | The path to the public key. Accepts an absolute path or a path relative to the `boltdir`. | `<boltdir>/keys/public_key.pkcs7.pem` |

### `pkcs7::secret_decrypt`

The `pkcs7::secret_decrypt` task decrypts an encrypted value and returns the plaintext. It accepts the following values:

| Option | Type | Description | Default |
| ------ | ---- | ----------- | ------- |
| `encrypted_value` | `String` | The encrypted value. |
| `private_key` | `String` | The path to the private key. Accepts an absolute path or a path relative to the `boltdir`. | `<boltdir>/keys/private_key.pkcs7.pem` |
| `public_key` | `String` | The path to the public key. Accepts an absolute path or a path relative to the `boltdir`. | `<boltdir>/keys/public_key.pkcs7.pem` |

### `pkcs7::secret_encrypt`

The `pkcs7::secret_encrypt` task encrypts a sensitive value and returns an encrypted value. It accepts the following values:

| Option | Type | Description | Default |
| ------ | ---- | ----------- | ------- |
| `plaintext_value` | `String` | The value to encrypt. |
| `public_key` | `String` | The path to the public key. Accepts an absolute path or a path relative to the `boltdir`. | `<boltdir>/keys/public_key.pkcs7.pem` |

## Configuration

The `pkcs7` plugin can be configured in a `bolt.yaml` file. The following values can be configured
and apply to each plugin that uses the value:

- `keysize`
- `private_key`
- `public_key`

## Usage

The `pkcs7::secret_decrypt` task is aliased to `resolve_reference`, letting it be used anywhere that a
`resolve_reference` task can be used such as a `bolt.yaml`, `inventory.yaml`, or a plan. To use the
plugin, write a plugin reference anywhere you need to decrypt an encrypted value:

```yaml
targets:
  - uri: example.com
    config:
      ssh:
        password:
          _plugin: pkcs7
          encrypted_value: |
            ENC[PKCS7,MY_ENCRYPTED_DATA]
```

## Bolt CLI Usage

The `pkcs7` plugins can be used directly from the Bolt CLI using the `bolt secret` commands. This module
is bundled with Bolt and is the default plugin used by the `bolt secret` commands.

### Creating keys

To create keys for a Bolt project, run the following command:

```bash
$ bolt secret createkeys [options]
```

### Decrypting a value

To decrypt an encrypted value, run the following command:

```bash
$ bolt secret decrypt <encrypted_value> [options]
```

### Encrypting a value

To encrypt plaintext, run the following command:

```bash
$ bolt secret encrypt <plaintext_value> [options]
```
