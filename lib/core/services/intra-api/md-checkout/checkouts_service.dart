import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/checkouts/calculate_request.model.dart';
import 'package:voucherize/models/checkouts/calculate_response.model.dart';
import 'package:voucherize/models/checkouts/checkout_request.model.dart';
import 'package:voucherize/models/checkouts/checkout_response.model.dart';
import 'package:voucherize/models/checkouts/payment_method.model.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:flutter/foundation.dart';


class CheckoutsService extends IntraApi {
	static final CheckoutsService instance = CheckoutsService();

	CheckoutsService() : super(Constants.getBaseUrl());

	/// GET /checkouts/client/methods
	Future<ValueResult<List<PaymentMethodModel>>> getPaymentMethods() async {
		try {
			const path = '/checkouts/client/methods';
			final response = await get(path);
			final data = response.data;
			if (data is List) {
				final list = data
						.map((e) => PaymentMethodModel.fromJson(Map<String, dynamic>.from(e as Map)))
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

	/// POST /checkouts/client/calculate
	Future<ValueResult<CalculateResponse>> calculateCart(CalculateRequest request) async {
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

	/// POST /checkouts/client
	Future<ValueResult<CheckoutResponse>> createCheckout(CheckoutRequest request) async {
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

	/// GET /checkouts/client/pix/status/:paymentId
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

