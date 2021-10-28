# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.1] - 2021-10-28
- **Breaking change for Supplier API**: When operating on `Article` or `Variant` one must provide scope 
  of `substrate` or `plate`. Calling `all` or `find` without scope will raise an `ArgumentError` 

## [0.2.2] - 2021-10-25

### Added
 - Add support for ordering material requirements

## [0.2.1] - 2021-10-18

### Fixed

- `with_token` keeps the preceding token instead of resetting

## [0.2.0] - 2021-10-13

### Added
- Added MaterialAvailabilityCheck for suppliers

## [0.1.1] - 2021-10-06

### Changed
- Updated MaterialRequirement attributes

## [0.1.0] - 2021-10-05

* Added support for material requirements

[Unreleased]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.3.1..HEAD
[0.3.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.2s..v0.3.1
[0.2.2]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.1s..v0.2.2
[0.2.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.0..v0.2.1
[0.2.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.1.1..v0.2.0
[0.1.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.1.0..v0.1.1
[0.1.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/3e84659a2eee172280a7e4f0434fd8ce0e373844..8c9a509b308290ba18c17ef68701fd451cb05d18
