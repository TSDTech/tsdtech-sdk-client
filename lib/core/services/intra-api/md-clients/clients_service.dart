import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-entity.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

/// Service for managing client user profiles.
///
/// This service provides methods for updating client user information
/// such as email, password, name, phone, and other profile details.
///
/// ## Usage
/// ```dart
/// final client = TsdtechClient();
/// final clientsService = client.clients;
/// final result = await clientsService.patchClient(
///   name: 'John Updated',
///   phone: '+5511999999999',
/// );
/// ```
///
/// Prefer scoped access via `TsdtechClient.clients`.
/// The legacy [ClientsService.instance] singleton remains available for
/// backward compatibility during the migration period.
class ClientsService extends IntraApi {
  /// Singleton instance of [ClientsService].
  @Deprecated(
    'Use TsdtechClient.clients to access a scoped service instance. '
    'This legacy singleton will be removed in a future major version.',
  )
  static final ClientsService instance = ClientsService();

  /// Creates a [ClientsService] instance with the base URL from [Constants].
  ClientsService({BaseApi? baseApi, String? baseUrl})
    : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Updates the authenticated client's profile information.
  ///
  /// All parameters are optional - only provided fields will be updated.
  ///
  /// - [email]: New email address (optional)
  /// - [password]: New password (optional)
  /// - [name]: New first name (optional)
  /// - [secondName]: New last name (optional)
  /// - [phone]: New phone number (optional)
  /// - [administratorId]: Administrator identifier (optional)
  /// - Returns: [ValueResult] containing the updated [ClientUserEntity]
  ///
  /// ## Example
  /// ```dart
  /// final result = await clientsService.patchClient(
  ///   name: 'John',
  ///   secondName: 'Doe',
  ///   phone: '+5511987654321',
  /// );
  /// if (result.isSuccess) {
  ///   print('Profile updated: ${result.value.name}');
  /// }
  /// ```
  Future<ValueResult<ClientUserEntity>> patchClient({
    String? email,
    String? password,
    String? name,
    String? secondName,
    String? phone,
    String? administratorId,
  }) async {
    try {
      final response = await patch(
        '/clients/ms/',
        data: {
          'name': name,
          'secondName': secondName,
          'phone': phone,
          'email': email,
          'password': password,
          'administratorId': administratorId,
        },
      );
      final client = ClientUserEntity.fromJson(
        response.data as Map<String, dynamic>,
      );
      return ValueResult.success(client);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
