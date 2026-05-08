import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/auth/client-user-entity.model.dart';
import 'package:voucherize/models/value_result.dart';

class ClientsService extends IntraApi {
  static final ClientsService instance = ClientsService();

  ClientsService() : super(Constants.getBaseUrl());

  Future<ValueResult<ClientUserEntity>> patchClient(
      {String? email,
      String? password,
      String? name,
      String? secondName,
      String? phone,
      String? administratorId}) async {
    try {
      final response = await patch('/clients/ms/', data: {
        'name': name,
        'secondName': secondName,
        'phone': phone,
        'email': email,
        'password': password,
        'administratorId': administratorId,
      });
      final client =
          ClientUserEntity.fromJson(response.data as Map<String, dynamic>);
      return ValueResult.success(client);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
