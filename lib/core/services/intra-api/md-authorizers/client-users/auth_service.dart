import 'package:voucherize/core/local_storage/auth_token/auth_token.prefs.dart';
import 'package:voucherize/core/local_storage/client_user_token_data/client_user_token_data.prefs.dart';
import 'package:voucherize/core/local_storage/shared_prefs_helper.dart';
import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/models/auth/client-user-token-data.model.dart';
import 'package:voucherize/models/auth/login-response-client.model.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/auth/signup-request-client.model.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/core/local_storage/administrator/administrator_id.prefs.dart';
import 'package:flutter/foundation.dart';

class AuthServiceClientUser extends IntraApi {
  static final AuthServiceClientUser instance = AuthServiceClientUser();

  AuthServiceClientUser() : super(Constants.getBaseUrl());

  ClientUserTokenData? get currentUser => ClientUserTokenDataPrefs.get();

  Future<ValueResult<LoginResponseClient>> login({
    required String email,
    required String password,
  }) async {
    try {
      final adminId = AdministratorIdPrefs.get();
      if (adminId == null || adminId.isEmpty) throw Exception('administratorId is required for login');

      final response = await post('/auth-client-users/public/login', data: {
        'email': email,
        'password': password,
        'administratorId': adminId,
      });

      final loginResponse = LoginResponseClient.fromJson(response.data);

      await AuthTokenPrefs.set(loginResponse.token);
      await ClientUserTokenDataPrefs.set(loginResponse.data);

      try {
        await _loadInitialData();
      } catch (e) {
        print('Erro ao carregar dados adicionais (client-user): $e');
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

  Future<ValueResult<LoginResponseClient>> signup(SignupRequestClient dto) async {
    try {
      await SharedPrefsHelper.prefs.clear();

      final adminId = AdministratorIdPrefs.get();
      if (adminId == null || adminId.isEmpty) throw Exception('administratorId is required for signup');

  final payload = dto.toJson()..removeWhere((k, v) => v == null);
  // remove legacy fullDomain param and replace by administratorId
  payload.remove('fullDomain');
  payload['administratorId'] = adminId;
  final response = await post('/auth-client-users/public/signup', data: payload);

      final loginResponse = LoginResponseClient.fromJson(response.data);

      await AuthTokenPrefs.set(loginResponse.token);
      await ClientUserTokenDataPrefs.set(loginResponse.data);

      try {
        await _loadInitialData();
      } catch (e) {
        print('Erro ao carregar dados adicionais (client-user signup): $e');
      }

      return ValueResult.success(loginResponse);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<void> _loadInitialData() async {}
}
