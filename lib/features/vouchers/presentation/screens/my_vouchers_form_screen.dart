import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';
import 'package:tsdtech_client_sdk/core/components/nav_header.dart';
import 'package:tsdtech_client_sdk/core/router/router.dart';
import 'package:get_it/get_it.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/provider_request_store.dart';
import 'package:tsdtech_client_sdk/features/vouchers/core/stores/vouchers_store.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/components/confirm_voucher_modal.dart';
import 'package:tsdtech_client_sdk/features/vouchers/presentation/components/dynamic_form.dart';
import 'package:tsdtech_client_sdk/core/services/intra-api/md-services/services/services_service.dart';
import 'package:tsdtech_client_sdk/models/providers/provider.model.dart';
import 'package:tsdtech_client_sdk/models/value_result.dart';
import 'package:tsdtech_client_sdk/models/common/paginated_list.model.dart';
import 'package:tsdtech_client_sdk/models/forms/service_form.model.dart';
import 'package:tsdtech_client_sdk/models/forms/service_form_field.model.dart';

// Custom SnackBar para sucesso/erro
void showTopSnackBar(BuildContext context,
    {required bool success, required String message}) {
  final color = success ? const Color(0xFFCCF7D8) : const Color(0xFFFFE0E0);
  final textColor = success ? const Color(0xFF199A4E) : const Color(0xFFD32F2F);
  final icon = success
      ? const Icon(Icons.check_circle_outline,
          color: Color(0xFF199A4E), size: 24)
      : const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 24);
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
    content: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
    duration: const Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

@RoutePage()
class MyVouchersFormScreen extends StatelessWidget {
  final String serviceId;
  final String formId;
  final String administratorId;
  const MyVouchersFormScreen(
      {super.key, required this.serviceId, required this.formId, required this.administratorId});

  Widget _buildDynamicForm(Map<String, dynamic> formSchema, VouchersStore store,
      BuildContext context,
      {GlobalKey? formKey}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DynamicForm(
          key: formKey,
          formSchema: formSchema,
          store: store,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
  final store = GetIt.instance<VouchersStore>();
  final providerRequestStore = GetIt.instance<ProviderRequestStore>();
  final _dynamicFormKey = GlobalKey<DynamicFormState>();
    final formFuture = ServicesService.instance.getServiceFormModel(formId: formId);
    store.resetFormValues();
    return Scaffold(
      appBar: const NavHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Builder(builder: (ctx) {
                final availableHeight = MediaQuery.of(ctx).size.height -
                    220; // leave room for header/margins
                // attempt to find a voucher/service object for display on the left column
                dynamic voucherObj;
                try {
                  voucherObj = store.vouchers
                      .firstWhere((v) => v.serviceId == serviceId);
                } catch (_) {
                  voucherObj = null;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Body header: back button + title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.black87),
                          onPressed: () {
                            try {
                              store.fetchMyVouchers();
                            } catch (_) {}
                            try {
                              providerRequestStore.fetchProviderRequests();
                            } catch (_) {}
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              context.router.replace(const MyVouchersRoute());
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: DsText(
                                text: 'Agendar Serviço',
                                variant: DsTextVariant.titleVoucher)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Main content: two columns constrained to availableHeight
                    SizedBox(
                      height: availableHeight < 400 ? 400 : availableHeight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left info column
                          Flexible(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DsText(
                                    text: voucherObj?.service?.name ?? '',
                                    variant: DsTextVariant.subTitleVoucher),
                                const SizedBox(height: 12),
                                DsText(
                                    text: 'Código do Serviço: $serviceId',
                                    variant: DsTextVariant.small),
                                const SizedBox(height: 8),
                                DsText(
                                    text: 'Voucher nº: ${voucherObj?.id ?? ''}',
                                    variant: DsTextVariant.small),
                                const SizedBox(height: 12),
                                FutureBuilder<ValueResult<ServiceForm>>(
                                  future: formFuture,
                                  builder: (ctx, snap) {
                                    if (snap.connectionState != ConnectionState.done) {
                                      return DsText(text: 'Carregando descrição...', variant: DsTextVariant.small);
                                    }
                                    final res = snap.data;
                                    if (res == null || res.isError || res.value == null) {
                                      return DsText(text: 'Descrição: ${voucherObj?.service?.description ?? ''}', variant: DsTextVariant.small);
                                    }
                                    final model = res.value!;
                                    return DsText(text: 'Descrição: ${model.description ?? voucherObj?.service?.description ?? ''}', variant: DsTextVariant.small);
                                  },
                                ),
                                const SizedBox(height: 12),
                                // Providers dropdown: delegate fetching to the VouchersStore
                                FutureBuilder<ValueResult<PaginatedList<ProviderModel>>>(
                                  future: store.fetchProvidersForService(serviceId),
                                  builder: (ctx, snap) {
                                    if (snap.connectionState != ConnectionState.done) {
                                      return DsText(text: 'Carregando prestadores...', variant: DsTextVariant.small);
                                    }
                                    if (snap.hasError) {
                                      return DsText(text: 'Erro ao carregar prestadores', variant: DsTextVariant.small);
                                    }
                                    final res = snap.data;
                                    if (res == null || res.isError || res.value == null) {
                                      return DsText(text: 'Nenhum prestador disponível', variant: DsTextVariant.small);
                                    }
                                    final page = res.value!;
                                    final providers = page.items.whereType<ProviderModel>().toList();
                                    if (providers.isEmpty) {
                                      return DsText(text: 'Nenhum prestador disponível', variant: DsTextVariant.small);
                                    }

                                    final selected = store.formValues['providerId'];
                                    return DropdownButtonFormField<String>(
                                      value: selected,
                                      items: providers.map((p) {
                                        final id = p.provider?.id ?? p.providerId ?? '';
                                        final label = p.provider?.name ?? p.serviceType?.name ?? id;
                                        return DropdownMenuItem(value: id, child: Text(label));
                                      }).toList(),
                                      onChanged: (v) => store.setFormValue('providerId', v ?? ''),
                                      decoration: InputDecoration(
                                        hintText: 'Selecione o prestador',
                                        filled: true,
                                        fillColor: const Color(0xFFF3F4F6),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // validate and collect payload from the dynamic form on the right
                                    final payload = _dynamicFormKey.currentState
                                        ?.validateAndCollect();
                                    if (payload == null) {
                                      showTopSnackBar(context,
                                          success: false,
                                          message:
                                              'Preencha todos os campos obrigatórios.');
                                      return;
                                    }

                                    final selectedProvider = store.formValues['providerId'];
                                    if (selectedProvider == null || selectedProvider.isEmpty) {
                                      showTopSnackBar(context,
                                          success: false,
                                          message: 'Selecione um prestador.');
                                      return;
                                    }

                                    final voucherId = voucherObj?.id ?? '';

                                    final providerSelectedId = selectedProvider;

                                    final voucherServiceId =
                                        store.vouchers.isNotEmpty
                                            ? store.vouchers.first.serviceId
                                            : serviceId;
                                    // open confirmation modal — submission will happen inside the modal when the user confirms
                                    showConfirmVoucherModal(
                                        context, store, voucherServiceId, administratorId, providerSelectedId, voucherId,
                                        payload: payload);
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: const DsText(
                                      text: 'Confirmar agendamento',
                                      variant: DsTextVariant.baseBold,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB)),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    } else {
                                      context.router
                                          .replace(const MyVouchersRoute());
                                    }
                                  },
                                  child: const DsText(
                                      text: 'Cancelar agendamento',
                                      variant: DsTextVariant.small,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Right form column (scrollable)
                          Flexible(
                            flex: 6,
                child: FutureBuilder<ValueResult<ServiceForm>>(
                  future: formFuture,
                              builder: (context, snapshot) {
                if (snapshot.connectionState !=
                  ConnectionState.done) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: DsText(
                                          text: 'Erro ao carregar formulário',
                                          variant: DsTextVariant.small));
                                }
                                final result = snapshot.data;
                                if (result == null || result.isError) {
                                  return Center(
                                      child: DsText(
                                          text: 'Erro ao carregar formulário',
                                          variant: DsTextVariant.small));
                                }
                                final model = result.value;
                                if (model == null) {
                                  return Center(
                                      child: DsText(
                                          text: 'Formulário não disponível',
                                          variant: DsTextVariant.small));
                                }

                                // Convert ServiceForm model into the generic schema expected by DynamicForm
                                final Map<String, dynamic> schema = {
                                  'type': 'object',
                                  'title': model.title,
                                  'description': model.description ?? '',
                                  'required': model.fields
                                      .where((f) => f.isRequired)
                                      .map((f) => f.id)
                                      .toList(),
                                  'properties': {
                                    for (final f in model.fields)
                                      f.id: _fieldToSchema(f),
                                  }
                                };

                                return SingleChildScrollView(
                                    child: _buildDynamicForm(
                                        schema, store, context,
                                        formKey: _dynamicFormKey));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to convert a ServiceFormField into the DynamicForm property schema
  static Map<String, dynamic> _fieldToSchema(ServiceFormField f) {
    // keep the original field type (e.g. 'select', 'text', 'number', 'validation')
    final Map<String, dynamic> schema = {
      'type': f.type,
      'label': f.label,
      'description': '',
      'placeholder': f.label,
    };
    if (f.options != null && f.options!.isNotEmpty) {
      schema['options'] = f.options;
    }
    if (f.validationKey != null) {
      schema['validationKey'] = f.validationKey;
    }
    return schema;
  }
}
