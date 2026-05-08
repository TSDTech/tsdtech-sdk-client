import 'package:voucherize/core/services/intra-api/intra.api.dart';
import 'package:voucherize/core/constants/constants.dart';
import 'package:voucherize/models/providers/provider.model.dart';
import 'package:voucherize/models/vouchers/provider_request.model.dart';
import 'package:voucherize/models/common/paginated_list.model.dart';
import 'package:voucherize/models/common/pagination.model.dart';
import 'package:voucherize/models/value_result.dart';

class ProviderRequestsService extends IntraApi {
  static final ProviderRequestsService instance =
      ProviderRequestsService();

  ProviderRequestsService()
      : super(Constants.getBaseUrl());

  Future<ValueResult<PaginatedList<ProviderRequest>>> getProviderRequestsClient(
      {Pagination? pagination,
      bool? clients,
      bool? service,
      bool? provider,
      bool? voucher,
      bool? administrator,
      String? status}) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (status != null) 'status': status,
        if (clients != null) 'clients': clients.toString(),
        if (service != null) 'service': service.toString(),
        if (provider != null) 'provider': provider.toString(),
        if (voucher != null) 'voucher': voucher.toString(),
        if (administrator != null) 'administrator': administrator.toString(),
      };
      const path = 'provider-request/client';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<ProviderRequest>.fromJson(
        response.data,
        (item) => ProviderRequest.fromJson(item as Map<String, dynamic>),
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }

  Future<ValueResult<PaginatedList<ProviderModel>>> getAllProvider (
    {
      Pagination? pagination,
      bool? serviceType,
      bool? providerBool,
      String? serviceId,
    }
  ) async {
    try {
      final queryParams = {
        'page': pagination?.page ?? 1,
        'pageSize': pagination?.pageCount ?? 10,
        if (serviceType != null) 'serviceType': serviceType.toString(),
        if (providerBool != null) 'provider': providerBool.toString(),
        if (serviceId != null) 'serviceId': serviceId,
      };
      const path = 'provider-service-types/client';
      final response = await get(path, queryParameters: queryParams);
      final paginated = PaginatedList<ProviderModel>.fromJson(
        response.data, (item) => ProviderModel.fromJson(item as Map<String, dynamic>)
      );
      return ValueResult.success(paginated);
    } catch (e) {
      return ValueResult.fromError(e);
    }
  }
}
