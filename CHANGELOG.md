# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-05-11

### Added

- Initial SDK foundation for TsdTech client integration
- BaseApi: Static HTTP client using Dio for making API requests
- IntraApi: Base class for intra-service API communication
- ValueResult<T>: Result type for handling success/failure responses
- VouchersService: Client voucher management (list, retrieve)
- CheckoutsService: Payment checkout flow (calculate, create, PIX status)
- AuthServiceClientUser: Client user authentication (login, signup)
- OrdersService: Client order management
- ClientsService: Client profile management
- AdministratorsService: Administrator operations
- MembershipsService: Membership/subscription management
- ApiKeysService: API key management
- ServicesService: Service catalog management
- ServiceTypesService: Service type definitions
- ProviderRequestsService: Provider request management
- Token-based authentication with Bearer tokens
- Error handling with user-friendly messages
- Pagination support for list operations
- Support for both card and PIX payment methods