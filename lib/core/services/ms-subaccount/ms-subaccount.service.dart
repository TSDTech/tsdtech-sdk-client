import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-entity.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';

/// Service for managing client user profiles.
///
/// This service provides methods for updating client user information
/// such as email, password, name, phone, and other profile details.
///
/// ## Usage
/// ```dart
/// final subaccountService = SubaccountService.instance;
/// final result = await subaccountService.patchClient(
///   name: 'John Updated',
///   phone: '+5511999999999',
/// );
/// ```
///
/// ## Singleton Pattern
/// Access the service via [SubaccountService.instance].
class SubaccountService extends IntraApi {
  /// Singleton instance of [SubaccountService].
  static final SubaccountService instance = SubaccountService();

  /// Creates a [SubaccountService] instance with the base URL from [Constants].
  SubaccountService() : super(Constants.getMsUrl('back-ms-subaccount'));

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
  /// final result = await subaccountService.patchClient(
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
        '/deposit/ms/',
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
