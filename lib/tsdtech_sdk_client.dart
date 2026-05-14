/// Public barrel file for the `tsdtech_client_sdk` package.
///
/// Exports main DTOs and models so consumers can import a single
/// package entrypoint instead of deeper `models/...` paths.

// Core helpers
export 'models/value_result.dart';

// Checkouts (DTOs and related models)
export 'models/checkouts/checkout_request.model.dart';
export 'models/checkouts/checkout_response.model.dart';
export 'models/checkouts/pix_data.model.dart';
export 'models/checkouts/bill_data.model.dart';
export 'models/checkouts/payment_method.model.dart';
export 'models/checkouts/calculate_item.model.dart';
export 'models/checkouts/calculate_request.model.dart';
export 'models/checkouts/calculate_response.model.dart';

// Providers / common models (convenience)
export 'models/common/pagination.model.dart';
export 'models/common/paginated_list.model.dart';
export 'models/common/address.model.dart';
