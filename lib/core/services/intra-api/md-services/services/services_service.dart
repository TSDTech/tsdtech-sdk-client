import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/common/pagination.model.dart';
import 'package:tsdtech_client_sdk/models/services/service.model.dart';
import 'package:tsdtech_client_sdk/models/forms/service_form.model.dart';
import 'dart:convert';

/// Service for managing services and service forms.
///
/// This service provides methods for listing public services, retrieving
/// service form models, and submitting service forms.
///
/// ## Usage
/// ```dart
/// final client = TsdtechClient();
/// final servicesService = client.services;
///
/// // List public services
/// final services = await servicesService.getPublicServices(
///   pagination: Pagination(page: 1, pageCount: 20),
///   status: 'active',
/// );
///
/// // Get service form
/// final form = await servicesService.getServiceFormModel(
///   formId: 'form-123',
/// );
///
/// // Submit service form
/// await servicesService.submitServiceForm(
///   formData,
///   serviceId: 'service-123',
///   administratorId: 'admin-123',
/// );
/// ```
///
/// Prefer scoped access via `TsdtechClient.services`.
/// The legacy [ServicesService.instance] singleton remains available for
/// backward compatibility during the migration period.
class ServicesService extends IntraApi {
  /// Singleton instance of [ServicesService].
  @Deprecated(
    'Use TsdtechClient.services to access a scoped service instance. '
    'This legacy singleton will be removed in a future major version.',
  )
  static final ServicesService instance = ServicesService();

  /// Creates a [ServicesService] instance with the base URL from [Constants].
  ServicesService({BaseApi? baseApi, String? baseUrl})
    : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves a list of public services with optional filtering.
  ///
  /// - [pagination]: Optional pagination parameters (page, pageCount)
  /// - [ids]: Filter by service IDs (optional)
  /// - [names]: Filter by service names (optional)
  /// - [codes]: Filter by service codes (optional)
  /// - [administratorIds]: Filter by administrator IDs (optional)
  /// - [status]: Filter by service status (optional, e.g., 'active')
  /// - [serviceTypeIds]: Filter by service type IDs (optional)
  /// - [searchTerm]: Search by name/code (optional)
  /// - [administrator]: Include administrator details (optional)
  /// - [serviceType]: Include service type details (optional)
  /// - Returns: [ValueResult] containing a [PaginatedList] of [Service] objects
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
        'status': ?status,
        if (serviceTypeIds != null && serviceTypeIds.isNotEmpty)
          'serviceTypeId': serviceTypeIds,
        'searchTerm': ?searchTerm,
        'administrator': ?administrator,
        'serviceType': ?serviceType,
        if (administratorIds != null && administratorIds.isNotEmpty)
          'administratorIds': administratorIds,
      };

      const path = '/services/public/';
      final response = await get(path, queryParameters: queryParams);

      final paginated = PaginatedList<Service>.fromJson(
        response.data as Map<String, dynamic>,
        (item) => Service.fromJson(item as Map<String, dynamic>),
      );

      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Retrieves a service form model by its ID.
  ///
  /// - [formId]: The ID of the service form to retrieve (required)
  /// - Returns: [ValueResult] containing the [ServiceForm] model
  ///
  /// ## Response Handling
  /// Handles multiple response formats:
  /// - List with 'form' field (string or Map)
  /// - Map with 'items' containing forms
  /// - Direct form object
  ///
  /// ## Error Handling
  /// Returns [ValueResult.failure] if:
  /// - Form not found
  /// - Invalid response format
  /// - Parsing fails
  Future<ValueResult<ServiceForm>> getServiceFormModel({
    required String formId,
  }) async {
    try {
      final queryParams = {'ids': formId};
      const path = '/service-forms/client';
      final response = await get(path, queryParameters: queryParams);
      final data = response.data;

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
          formJson = Map<String, dynamic>.from(
            data['form'] as Map<String, dynamic>,
          );
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

  /// Submits a service form with the provided payload.
  ///
  /// - [payload]: The form data to submit as a Map
  /// - [serviceId]: Optional service ID to associate (optional)
  /// - [administratorId]: Optional administrator ID (optional)
  /// - [voucherId]: Optional voucher ID (optional)
  /// - [providerId]: Optional provider ID (optional)
  /// - Returns: [ValueResult] containing true on successful submission
  ///
  /// ## Example
  /// ```dart
  /// final result = await servicesService.submitServiceForm(
  ///   {
  ///     'field1': 'value1',
  ///     'field2': 'value2',
  ///   },
  ///   serviceId: 'service-123',
  ///   voucherId: 'voucher-456',
  /// );
  /// if (result.isSuccess && result.value) {
  ///   print('Form submitted successfully');
  /// }
  /// ```
  Future<ValueResult<bool>> submitServiceForm(
    Map<String, dynamic> payload, {
    String? serviceId,
    String? administratorId,
    String? voucherId,
    String? providerId,
  }) async {
    try {
      const path = '/service-forms/client/submit';
      final requestData = Map<String, dynamic>.from(payload);
      if (serviceId != null) requestData['serviceId'] = serviceId;
      if (administratorId != null) {
        requestData['administratorId'] = administratorId;
      }
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
