/// Public barrel file for the `tsdtech_client_sdk` package.
///
/// Exports main DTOs and models so consumers can import a single
/// package entrypoint instead of deeper `models/...` paths.

// Core helpers
export 'models/value_result.dart';

// Core services
export 'core/services/base.api.dart';
export 'core/services/intra-api/intra.api.dart';
export 'core/constants/constants.dart';

// Crypto
export 'src/crypto/card_encryptor.dart';

// Checkouts (DTOs and related models)
export 'models/checkouts/checkout_request.model.dart';
export 'models/checkouts/checkout_response.model.dart';
export 'models/checkouts/pix_data.model.dart';
export 'models/checkouts/bill_data.model.dart';
export 'models/checkouts/payment_method.model.dart';
export 'models/checkouts/calculate_item.model.dart';
export 'models/checkouts/calculate_request.model.dart';
export 'models/checkouts/calculate_response.model.dart';

// Checkout service
export 'core/services/intra-api/md-checkout/checkouts_service.dart';

// Providers / common models (convenience)
export 'models/common/pagination.model.dart';
export 'models/common/paginated_list.model.dart';
export 'models/common/address.model.dart';

// Utils
export 'core/utils/date_formatter.dart';
export 'core/utils/search_utils.dart';
export 'core/utils/unix_datetime.decorator.dart';
