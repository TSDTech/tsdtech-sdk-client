import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/administrators/administrator.model.dart';

/// Service for managing administrator operations.
///
/// This service provides methods for querying administrator information,
/// such as retrieving administrator details by full domain.
///
/// ## Usage
/// ```dart
/// final adminsService = AdministratorsService.instance;
/// final result = await adminsService.getByFullDomain(
///   fullDomain: 'company.tsdtech.com',
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [AdministratorsService.instance].
class AdministratorsService extends IntraApi {
  /// Singleton instance of [AdministratorsService].
  static final AdministratorsService instance = AdministratorsService();

  /// Creates an [AdministratorsService] instance with the base URL from [Constants].
  AdministratorsService({BaseApi? baseApi, String? baseUrl})
      : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Retrieves administrator details by full domain.
  ///
  /// - [fullDomain]: The fully qualified domain of the administrator (required)
  /// - Returns: [ValueResult] containing the [Administrator] object
  ///
  /// ## Example
  /// ```dart
  /// final result = await adminsService.getByFullDomain(
  ///   fullDomain: 'acme.c破天',
  /// );
  /// result.fold(
  ///   (admin) => print('Admin: ${admin.name}'),
  ///   (error) => print('Error: $error'),
  /// );
  /// ```
  Future<ValueResult<Administrator>> getByFullDomain({
    required String fullDomain,
  }) async {
    try {
      final response = await get('/administrators/public/$fullDomain');
      final admin = Administrator.fromJson(
        response.data as Map<String, dynamic>,
      );
      return ValueResult.success(admin);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
