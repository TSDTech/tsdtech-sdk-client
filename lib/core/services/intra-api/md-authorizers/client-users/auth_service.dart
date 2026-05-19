import 'package:tsdtech_client_sdk/core/services/intra-api/intra.api.dart';
import 'package:tsdtech_client_sdk/models/auth/login-response-client.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/auth/signup-request-client.model.dart';
import 'package:tsdtech_client_sdk/core/constants/constants.dart';
import 'package:tsdtech_client_sdk/core/services/base.api.dart';

/// Service for client user authentication operations.
///
/// This service handles login and signup for client users.
/// It extends [IntraApi] to communicate with the authentication microservice.
///
/// ## Token Management
/// This service does NOT automatically store tokens. After successful login/signup,
/// use [BaseApi.setToken] to set the token for subsequent authenticated requests:
///
/// ```dart
/// final result = await authService.login(email: 'user@example.com', password: 'pass');
/// if (result.isSuccess) {
///   BaseApi.setToken(result.value.token);
/// }
/// ```
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
/// ## Singleton Pattern
/// Access the service via [AuthServiceClientUser.instance].
class AuthServiceClientUser extends IntraApi {
  /// Singleton instance of [AuthServiceClientUser].
  static final AuthServiceClientUser instance = AuthServiceClientUser();

  /// Creates an [AuthServiceClientUser] instance with the base URL from [Constants].
  AuthServiceClientUser({BaseApi? baseApi, String? baseUrl})
      : super(baseUrl ?? Constants.getBaseUrl(), baseApi: baseApi);

  /// Applies the auth token to the API client backing this service instance.
  void setAuthToken(String? token) {
    baseApi.applyToken(token);
  }

  /// Clears the auth token from the API client backing this service instance.
  void clearAuthToken() {
    baseApi.clearToken();
  }

  /// Authenticates a client user with the provided credentials.
  ///
  /// - [email]: The user's email address (required)
  /// - [password]: The user's password (required)
  /// - [administratorId]: The administrator ID (required)
  /// - Returns: [ValueResult] containing [LoginResponseClient] on success
  ///
  /// ## Requirements
  /// - [administratorId] must be provided
  ///
  /// ## Token Storage
  /// This method does NOT automatically store the token. After successful login,
  /// use [BaseApi.setToken] to set the token for subsequent requests:
  /// ```dart
  /// BaseApi.setToken(result.value.token);
  /// ```
  ///
  /// ## Error Handling
  /// Returns [ValueResult.failure] if:
  /// - administratorId is not provided
  /// - Network error occurs
  /// - API returns an error response
  ///
  /// ## Example
  /// ```dart
  /// final result = await authService.login(
  ///   email: 'user@example.com',
  ///   password: 'secret',
  ///   administratorId: 'admin-123',
  /// );
  /// result.fold(
  ///   (response) => print('Logged in: ${response.token}'),
  ///   (error) => print('Login failed: $error'),
  /// );
  /// ```
  Future<ValueResult<LoginResponseClient>> login({
    required String email,
    required String password,
    required String administratorId,
  }) async {
    try {
      if (administratorId.isEmpty) {
        throw Exception('administratorId is required for login');
      }

      final response = await post(
        '/auth-client-users/public/login',
        data: {
          'email': email,
          'password': password,
          'administratorId': administratorId,
        },
      );

      final loginResponse = LoginResponseClient.fromJson(
        response.data as Map<String, dynamic>,
      );

      return ValueResult.success(loginResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  /// Registers a new client user with the provided [dto].
  ///
  /// - [dto]: The signup request containing user details
  /// - [administratorId]: The administrator ID (required)
  /// - Returns: [ValueResult] containing [LoginResponseClient] on success
  ///
  /// ## Requirements
  /// - [administratorId] must be provided
  ///
  /// ## Payload Transformation
  /// The method removes the legacy 'fullDomain' field and replaces it
  /// with 'administratorId' in the request payload.
  ///
  /// ## Token Storage
  /// This method does NOT automatically store the token. After successful signup,
  /// use [BaseApi.setToken] to set the token for subsequent requests.
  ///
  /// ## Error Handling
  /// Returns [ValueResult.failure] if administratorId is not provided
  /// or if the API returns an error.
  ///
  /// ## Example
  /// ```dart
  /// final result = await authService.signup(
  ///   SignupRequestClient(
  ///     email: 'new@example.com',
  ///     password: 'pass123',
  ///     name: 'John Doe',
  ///   ),
  ///   administratorId: 'admin-123',
  /// );
  /// ```
  Future<ValueResult<LoginResponseClient>> signup(
    SignupRequestClient dto, {
    required String administratorId,
  }) async {
    try {
      if (administratorId.isEmpty) {
        throw Exception('administratorId is required for signup');
      }

      final payload = dto.toJson()..removeWhere((k, v) => v == null);
      // remove legacy fullDomain param and replace by administratorId
      payload.remove('fullDomain');
      payload['administratorId'] = administratorId;
      final response = await post(
        '/auth-client-users/public/signup',
        data: payload,
      );

      final loginResponse = LoginResponseClient.fromJson(
        response.data as Map<String, dynamic>,
      );

      return ValueResult.success(loginResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
