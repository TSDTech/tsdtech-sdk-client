import 'package:tsdtech_client_sdk/core/local_storage/auth_token/auth_token.prefs.dart';
import 'package:tsdtech_client_sdk/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:tsdtech_client_sdk/core/local_storage/shared_prefs_helper.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/models/auth/client-user-token-data.model.dart';
import 'package:tsdtech_client_sdk/models/auth/login-response-client.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/auth/signup-request-client.model.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:flutter/foundation.dart';

/// Service for client user authentication operations.
///
/// This service handles login, signup, and session management for client users.
/// It extends [IntraApi] to communicate with the authentication microservice.
///
/// ## Usage
/// ```dart
/// final authService = AuthServiceClientUser.instance;
///
/// // Login
/// final loginResult = await authService.login(
///   email: 'user@example.com',
///   password: 'password',
/// );
///
/// // Signup
/// final signupResult = await authService.signup(
///   SignupRequestClient(email: 'new@example.com', password: 'pass'),
/// );
/// ```
///
/// ## Authentication State
/// Use [currentUser] to get the currently authenticated user's token data.
/// Returns null if no user is logged in.
///
/// ## Singleton Pattern
/// Access the service via [AuthServiceClientUser.instance].
class AuthServiceClientUser extends IntraApi {
  /// Singleton instance of [AuthServiceClientUser].
  static final AuthServiceClientUser instance = AuthServiceClientUser();

  /// Creates an [AuthServiceClientUser] instance with the base URL from [Constants].
  AuthServiceClientUser() : super(Constants.getBaseUrl());

  /// Returns the currently authenticated client's token data.
  ///
  /// Returns null if no user is currently authenticated.
  /// The token data is persisted in [ClientUserTokenDataPrefs].
  ClientUserTokenData? get currentUser => ClientUserTokenDataPrefs.get();

  /// Authenticates a client user with the provided credentials.
  ///
  /// - [email]: The user's email address (required)
  /// - [password]: The user's password (required)
  /// - Returns: [ValueResult] containing [LoginResponseClient] on success
  ///
  /// ## Requirements
  /// - [AdministratorIdPrefs] must be set before calling this method
  /// - On success, automatically stores the auth token and user data
  ///
  /// ## Error Handling
  /// Returns [ValueResult.failure] if:
  /// - administratorId is not configured
  /// - Network error occurs
  /// - API returns an error response
  ///
  /// ## Example
  /// ```dart
  /// final result = await authService.login(
  ///   email: 'user@example.com',
  ///   password: 'secret',
  /// );
  /// result.fold(
  ///   (response) => print('Logged in: ${response.token}'),
  ///   (error) => print('Login failed: $error'),
  /// );
  /// ```
  Future<ValueResult<LoginResponseClient>> login({
    required String email,
    required String password,
  }) async {
    try {
      final adminId = AdministratorIdPrefs.get();
      if (adminId == null || adminId.isEmpty)
        throw Exception('administratorId is required for login');

      final response = await post('/auth-client-users/public/login', data: {
        'email': email,
        'password': password,
        'administratorId': adminId,
      });

      final loginResponse =
          LoginResponseClient.fromJson(response.data as Map<String, dynamic>);

      await AuthTokenPrefs.set(loginResponse.token);
      await ClientUserTokenDataPrefs.set(loginResponse.data);

      try {
        await _loadInitialData();
      } catch (e) {
        debugPrint('Erro ao carregar dados adicionais (client-user): $e');
      }

      return ValueResult.success(loginResponse);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[AuthServiceClientUser] login error: $e');
        debugPrint(st.toString());
      }
      return ValueResult.fromError(e);
    }
  }

  /// Registers a new client user with the provided [dto].
  ///
  /// - [dto]: The signup request containing user details
  /// - Returns: [ValueResult] containing [LoginResponseClient] on success
  ///
  /// ## Requirements
  /// - [AdministratorIdPrefs] must be set before calling this method
  /// - Clears all previous SharedPreferences before signup
  /// - On success, automatically stores the auth token and user data
  ///
  /// ## Payload Transformation
  /// The method removes the legacy 'fullDomain' field and replaces it
  /// with 'administratorId' in the request payload.
  ///
  /// ## Error Handling
  /// Returns [ValueResult.failure] if administratorId is not configured
  /// or if the API returns an error.
  ///
  /// ## Example
  /// ```dart
  /// final result = await authService.signup(
  ///   SignupRequestClient(
  ///     email: 'newuser@example.com',
  ///     password: 'password123',
  ///     name: 'John Doe',
  ///   ),
  /// );
  /// ```
  Future<ValueResult<LoginResponseClient>> signup(
      SignupRequestClient dto) async {
    try {
      await SharedPrefsHelper.prefs.clear();

      final adminId = AdministratorIdPrefs.get();
      if (adminId == null || adminId.isEmpty)
        throw Exception('administratorId is required for signup');

      final payload = dto.toJson()..removeWhere((k, v) => v == null);
      // remove legacy fullDomain param and replace by administratorId
      payload.remove('fullDomain');
      payload['administratorId'] = adminId;
      final response =
          await post('/auth-client-users/public/signup', data: payload);

      final loginResponse =
          LoginResponseClient.fromJson(response.data as Map<String, dynamic>);

      await AuthTokenPrefs.set(loginResponse.token);
      await ClientUserTokenDataPrefs.set(loginResponse.data);

      try {
        await _loadInitialData();
      } catch (e) {
        debugPrint(
            'Erro ao carregar dados adicionais (client-user signup): $e');
      }

      return ValueResult.success(loginResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Loads additional initial data after successful authentication.
  ///
  /// This method is called automatically after login/signup succeed.
  /// Override this method in subclasses to load additional user-specific data.
  Future<void> _loadInitialData() async {}
}
