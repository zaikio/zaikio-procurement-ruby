# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [2.1.1] - 2022-09-09
### Changed
 - Updated `MaterialRequirement` associations
## [2.1.0] - 2022-08-15
- Reuse client helpers to enable `Zaikio::Client.with_token(...)`
## [2.0.2] - 2022-08-05
### Changed
 - **Removed** `Zaikio::Procurement::Supplier#create_contract_request(...)` in favor of `Zaikio::Procurement::Supplier#contract_requests.create(...)` to get errors in the same way as the ActiveModel::Errors
## [2.0.1] - 2022-08-04
### Added
- `Zaikio::Procurement::Supplier#create_contract_request(...)` which is closer to the actual API specification
### Removed
- `Zaikio::Procurement::ContractRequest.create(supplier_id: ...)`
## [2.0.0] - 2022-08-04
  * **BREAKING CHANGE:** Support for Consumer API v1(legacy) and Supplier API has been completely removed.
  For the the supplier API, you have to stick with **[v0.4.1](  https://github.com/zaikio/zaikio-procurement-ruby/tree/v0.4.1)**
## [0.4.1] - 2022-02-10
### Added
 - Added distributors to suppliers

### Removed
- **Breaking change for Consumer API**: Removed `processed_at` timestamp for material requirements
- **Breaking change for Supplier API**: Removed MaterialAvailabilityCheck for suppliers

## [0.4.0]

### Added
- Added OrderConditionsInquiry for suppliers

## [0.3.2]

- Turn `Delivery#address` into a separate `Zaikio::Procurement::Address` object. This
  change is breaking if you previously depended on this property being a Hash.

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

[Unreleased]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v2.1.1..HEAD
[2.1.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v2.1.0..v2.1.1
[2.1.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v2.0.2..v2.1.0
[2.0.2]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v2.0.1..v2.0.2
[2.0.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v2.0.0..v2.0.1
[2.0.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.4.1..v2.0.0
[0.4.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.4.0..v0.4.1
[0.4.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.3.2..v0.4.0
[0.3.2]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.3.1..v0.3.2
[0.3.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.2..v0.3.1
[0.2.2]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.1..v0.2.2
[0.2.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.2.0..v0.2.1
[0.2.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.1.1..v0.2.0
[0.1.1]: https://github.com/zaikio/zaikio-procurement-ruby/compare/v0.1.0..v0.1.1
[0.1.0]: https://github.com/zaikio/zaikio-procurement-ruby/compare/3e84659a2eee172280a7e4f0434fd8ce0e373844..8c9a509b308290ba18c17ef68701fd451cb05d18
