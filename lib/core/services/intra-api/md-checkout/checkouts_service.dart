import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/calculate_response.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_request.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/checkout_response.model.dart';
import 'package:tsdtech_client_sdk/models/checkouts/payment_method.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:flutter/foundation.dart';

/// Service for handling checkout and payment operations.
///
/// This service provides methods for managing payment methods, calculating
/// cart totals, creating checkouts, and checking PIX payment status.
///
/// ## Usage
/// ```dart
/// final checkoutService = CheckoutsService.instance;
///
/// // Get available payment methods
/// final methods = await checkoutService.getPaymentMethods();
///
/// // Calculate cart total
/// final calculated = await checkoutService.calculateCart(request);
///
/// // Create checkout
/// final result = await checkoutService.createCheckout(checkoutRequest);
/// ```
///
/// ## Singleton Pattern
/// Access the service via [CheckoutsService.instance].
class CheckoutsService extends IntraApi {
  /// Singleton instance of [CheckoutsService].
  static final CheckoutsService instance = CheckoutsService();

  /// Creates a [CheckoutsService] instance with the base URL from [Constants].
  CheckoutsService() : super(Constants.getBaseUrl());

  /// Retrieves the list of available payment methods for the current user.
  ///
  /// - Returns: [ValueResult] containing a list of [PaymentMethodModel] objects
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.getPaymentMethods();
  /// if (result.isSuccess) {
  ///   for (final method in result.value) {
  ///     print('${method.id}: ${method.name}');
  ///   }
  /// }
  /// ```
  Future<ValueResult<List<PaymentMethodModel>>> getPaymentMethods() async {
    try {
      const path = '/checkouts/client/methods';
      final response = await get(path);
      final data = response.data;
      if (data is List) {
        final list = data
            .map((e) => PaymentMethodModel.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList();
        return ValueResult.success(list);
      }
      return ValueResult.success(<PaymentMethodModel>[]);
    } catch (e, st) {
      debugPrint('[CheckoutsService] getPaymentMethods error: $e');
      if (kDebugMode) debugPrint(st.toString());
      return ValueResult.fromError(e);
    }
  }

  /// Calculates the cart total based on the provided [request].
  ///
  /// - [request]: The [CalculateRequest] containing cart items and configuration
  /// - Returns: [ValueResult] containing the [CalculateResponse] with totals
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.calculateCart(
  ///   CalculateRequest(items: myItems, paymentMethodId: 'card'),
  /// );
  /// ```
  Future<ValueResult<CalculateResponse>> calculateCart(
      CalculateRequest request) async {
    try {
      const path = '/checkouts/client/calculate';
      final response = await post(path, data: request.toJson());
      final data = response.data as Map<String, dynamic>;
      final result = CalculateResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e, st) {
      debugPrint('[CheckoutsService] calculateCart error: $e');
      if (kDebugMode) debugPrint(st.toString());
      return ValueResult.fromError(e);
    }
  }

  /// Creates a new checkout with the provided [request].
  ///
  /// - [request]: The [CheckoutRequest] containing order details and payment info
  /// - Returns: [ValueResult] containing the [CheckoutResponse] with confirmation
  ///
  /// ## Example
  /// ```dart
  /// final result = await checkoutService.createCheckout(
  ///   CheckoutRequest(items: items, paymentMethodId: 'pix'),
  /// );
  /// if (result.isSuccess) {
  ///   print('Checkout created: ${result.value.paymentId}');
  /// }
  /// ```
  Future<ValueResult<CheckoutResponse>> createCheckout(
      CheckoutRequest request) async {
    try {
      const path = '/checkouts/client';
      final response = await post(path, data: request.toJson());
      final data = response.data as Map<String, dynamic>;
      final result = CheckoutResponse.fromJson(data);
      return ValueResult.success(result);
    } catch (e, st) {
      debugPrint('[CheckoutsService] createCheckout error: $e');
      if (kDebugMode) debugPrint(st.toString());
      return ValueResult.fromError(e);
    }
  }

  /// Retrieves the status of a PIX payment by its [paymentId].
  ///
  /// - [paymentId]: The unique identifier of the payment
  /// - Returns: [ValueResult] containing the status string (e.g., 'pending', 'completed')
  ///
  /// ## Example
  /// ```dart
  /// final status = await checkoutService.getPixStatus(paymentId);
  /// if (status.isSuccess) {
  ///   print('PIX Status: ${status.value}');
  /// }
  /// ```
  Future<ValueResult<String>> getPixStatus(String paymentId) async {
    try {
      final path = '/checkouts/client/pix/status/$paymentId';
      final response = await get(path);
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';
      return ValueResult.success(status);
    } catch (e, st) {
      debugPrint('[CheckoutsService] getPixStatus error: $e');
      if (kDebugMode) debugPrint(st.toString());
      return ValueResult.fromError(e);
    }
  }
}
