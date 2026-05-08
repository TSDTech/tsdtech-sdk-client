import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/services/service.model.dart';
import 'package:voucherize/models/forms/service_form.model.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ServicesService extends IntraApi {
  static final ServicesService instance = ServicesService();

  ServicesService() : super(Constants.getBaseUrl());

  Future<ValueResult<PaginatedList<Service>>> getPublicServices({
    Pagination? pagination,
    List<String>? ids,
    List<String>? names,
    List<String>? codes,
    List<String>? administratorIds,
    String? status,
    List<String>? serviceTypeIds,
    String? searchTerm,
    bool? administrator,
    bool? serviceType,
  }) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (ids != null && ids.isNotEmpty) 'ids': ids,
        if (names != null && names.isNotEmpty) 'names': names,
        if (codes != null && codes.isNotEmpty) 'codes': codes,
        if (status != null) 'status': status,
        if (serviceTypeIds != null && serviceTypeIds.isNotEmpty)
          'serviceTypeId': serviceTypeIds,
        if (searchTerm != null) 'searchTerm': searchTerm,
        if (administrator != null) 'administrator': administrator,
        if (serviceType != null) 'serviceType': serviceType,
        if (administratorIds != null && administratorIds.isNotEmpty)
          'administratorIds': administratorIds,
      };

      const path = '/services/public/';
      final response = await get(path, queryParameters: queryParams);

      final paginated = PaginatedList<Service>.fromJson(
        response.data,
        (item) => Service.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<ServiceForm>> getServiceFormModel(
      {required String formId}) async {
    try {
      final queryParams = {
        'ids': formId,
      };
      const path = '/service-forms/client';
      final response = await get(path, queryParameters: queryParams);
      final data = response.data;

      try {
        debugPrint(
            'ServicesService.getServiceFormModel raw response: ${response.data}');
      } catch (_) {}

      if (data is List && data.isNotEmpty) {
        final first = data.first as Map<String, dynamic>;

        if (first.containsKey('form') && first['form'] is String) {
          try {
            final parsed =
                json.decode(first['form'] as String) as Map<String, dynamic>;
            parsed['id'] = parsed['id'] ?? first['id'];
            parsed['clientId'] = parsed['clientId'] ?? first['clientId'];
            final model = ServiceForm.fromJson(parsed);
            return ValueResult.success(model);
          } catch (_) {
            return ValueResult.failure('Form parsing failed for envelope item');
          }
        }

        if (first.containsKey('form') && first['form'] is Map) {
          final formObj = Map<String, dynamic>.from(first['form'] as Map);
          formObj['id'] = formObj['id'] ?? first['id'];
          formObj['clientId'] = formObj['clientId'] ?? first['clientId'];
          final model = ServiceForm.fromJson(formObj);
          return ValueResult.success(model);
        }

        try {
          final fallback = Map<String, dynamic>.from(first);
          final modelFallback = ServiceForm.fromJson(fallback);
          return ValueResult.success(modelFallback);
        } catch (_) {
          return ValueResult.failure('Form parsing failed for envelope item');
        }
      }

      if (data is Map<String, dynamic>) {
        Map<String, dynamic> formJson;
        if (data.containsKey('items') &&
            data['items'] is List &&
            (data['items'] as List).isNotEmpty) {
          final first = (data['items'] as List).first as Map<String, dynamic>;

          if (first.containsKey('form')) {
            final formRaw = first['form'];
            if (formRaw is String) {
              try {
                formJson = json.decode(formRaw) as Map<String, dynamic>;
              } catch (_) {
                formJson = Map<String, dynamic>.from(first);
              }
            } else if (formRaw is Map) {
              formJson = Map<String, dynamic>.from(formRaw);
            } else {
              formJson = Map<String, dynamic>.from(first);
            }
            formJson['id'] = formJson['id'] ?? first['id'];
            formJson['clientId'] = formJson['clientId'] ?? first['clientId'];
          } else {
            formJson = Map<String, dynamic>.from(first);
          }
        } else if (data.containsKey('form') && data['form'] is Map) {
          formJson =
              Map<String, dynamic>.from(data['form'] as Map<String, dynamic>);
          formJson['id'] = formJson['id'] ?? data['id'];
        } else {
          formJson = data;
        }

        final model = ServiceForm.fromJson(formJson);
        return ValueResult.success(model);
      }

      return ValueResult.failure('Form not found or invalid response format');
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<bool>> submitServiceForm(Map<String, dynamic> payload,
      {String? serviceId, String? administratorId, String? voucherId, String? providerId}) async {
    try {
      const path = '/service-forms/client/submit';
      final requestData = Map<String, dynamic>.from(payload);
      if (serviceId != null) requestData['serviceId'] = serviceId;
      if (administratorId != null)
        requestData['administratorId'] = administratorId;
      if (voucherId != null) requestData['voucherId'] = voucherId;
      if (providerId != null) requestData['providerId'] = providerId;
      final response = await post(path, data: requestData);
      final sc = response.statusCode;
      if (sc != null && sc >= 200 && sc < 300) {
        return ValueResult.success(true);
      }
      return ValueResult.success(false);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
