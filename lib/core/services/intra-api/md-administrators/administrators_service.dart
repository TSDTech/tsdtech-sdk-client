import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/administrators/administrator.model.dart';

class AdministratorsService extends IntraApi {
  static final AdministratorsService instance = AdministratorsService();

  AdministratorsService() : super(Constants.getBaseUrl());

  Future<ValueResult<Administrator>> getByFullDomain({required String fullDomain}) async {
    try {
      final response = await get('/administrators/public/$fullDomain');
      final admin = Administrator.fromJson(response.data as Map<String, dynamic>);
      return ValueResult.success(admin);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
