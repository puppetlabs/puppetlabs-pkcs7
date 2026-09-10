# Changelog Archive

Release notes prior to [v1.0.0](CHANGELOG.md) (Puppet 9 / PDK modernization), generated before this
module adopted the [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)-based automated release
process. Kept for historical reference only; not parsed by the release tooling.

## [v0.1.2]()

### Bug fixes

* **Update secret_decrypt plugin description from 'encrypt' to 'decrypt'**
  
  Fixes a typo in the secret_decrypt plugin description.

## Release 0.1.1

### Bug fixes

* **Fix uninitialized constant PKCS7CreateKeys::FileUtils error**

  Fixed a bug in `pkcs7::secret_createkeys` where an exception was thrown with an error: `uninitialized constant PKCS7CreateKeys::FileUtils`

  Contributed by Nick Maludy (@nmaludy)
  
* **Fix shebang in tasks**
  
  The interpreter for tasks had a space in fron the prevented the correct interpreter from being
  declared

## Release 0.1.0

This is the initial release.
