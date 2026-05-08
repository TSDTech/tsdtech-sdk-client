import 'package:get_it/get_it.dart';
import 'package:voucherize/core/services/intra-api/md-clients/back_ms_client.module.dart';
import 'package:voucherize/core/services/intra-api/md-providers/back_ms_provider_request.module.dart';
import 'package:voucherize/core/services/intra-api/md-vouchers/back_ms_voucher.module.dart';

import 'package:voucherize/core/utils/module.base.dart';
import 'package:voucherize/core/services/intra-api/md-authorizers/back_ms_authorizer.module.dart';
import 'package:voucherize/core/services/intra-api/md-services/back_ms_services.module.dart';
import 'package:voucherize/core/services/intra-api/md-administrators/back_ms_administrators.module.dart';

class IntraApiModule extends ModuleBase {
  @override
  List<ModuleBase> get imports => [
        BackMsAuthorizerModule(),
        BackMsServicesModule(),
        BackMsAdministratorsModule(),
        BackMsVouchersModule(),
        BackMsClientsModule(),
        BackMsProviderRequestModule(),
      ];

  @override
  void inject(GetIt sl) {}
}
