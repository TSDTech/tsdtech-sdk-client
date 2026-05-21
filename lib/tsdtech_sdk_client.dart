// Public barrel file for the `tsdtech_client_sdk` package.
//
// Exports main DTOs and models so consumers can import a single
// package entrypoint instead of deeper `models/...` paths.
// Internal implementation stays behind dedicated public wrappers.

export 'tsdtech_sdk_ui.dart';

// Core helpers
export 'models/value_result.dart';

// Core services
export 'core/services/base.api.dart';
export 'core/services/intra-api/intra.api.dart';
export 'core/services/gateway_service.dart';
export 'core/constants/constants.dart';

// Crypto
export 'crypto/card_encryptor.dart';

// Checkouts (DTOs and related models)
export 'models/checkouts/checkout_request.model.dart';
export 'models/checkouts/checkout_response.model.dart';
export 'models/checkouts/pix_data.model.dart';
export 'models/checkouts/payment_method.model.dart';
export 'models/checkouts/calculate_item.model.dart';
export 'models/checkouts/calculate_request.model.dart';
export 'models/checkouts/calculate_response.model.dart';
export 'models/cart/cart_item.model.dart';

// Gateway DTOs (from PR #2)
export 'dto/gateway/public_key_response.dart';
export 'dto/gateway/card_payment_request.dart';
export 'dto/gateway/payment_status_response.dart';
export 'dto/gateway/gateway_payment_status.dart';

// Gateway Client & Service (from PR #3)
export 'client/gateway_client.dart' show GatewayClient;
export 'client/tsdtech_client.dart' show TsdtechClient;

// Checkout Orchestrator
export 'src/services/checkout_orchestrator.dart' show CheckoutOrchestrator;

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
