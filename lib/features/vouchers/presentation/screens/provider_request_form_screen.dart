import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:voucherize/core/components/nav_header.dart';
import 'package:voucherize/core/components/ds_text.dart';
import 'package:get_it/get_it.dart';
import 'package:voucherize/features/vouchers/core/stores/provider_request_store.dart';
import 'package:voucherize/core/services/intra-api/md-services/services/services_service.dart';
import 'package:voucherize/models/value_result.dart';
import 'package:voucherize/models/forms/service_form.model.dart';
import 'package:voucherize/models/forms/service_form_field.model.dart';
import 'package:voucherize/models/vouchers/provider_request.model.dart';
import 'package:voucherize/core/router/router.dart';
import 'package:voucherize/features/vouchers/core/stores/vouchers_store.dart';
import 'package:voucherize/features/vouchers/presentation/components/dynamic_form.dart';
import 'package:voucherize/features/vouchers/presentation/components/confirm_voucher_modal.dart';

@RoutePage()
class ProviderRequestFormScreen extends StatelessWidget {
  final String providerRequestId;
  final String serviceId;
  final String administratorId;
  const ProviderRequestFormScreen({super.key, required this.providerRequestId, required this.serviceId, required this.administratorId});

  // Keep a fallback static schema if no formId is available from the provider request.
  Map<String, dynamic>? _getFallbackSchemaForProviderRequest(String providerRequestId) {
    return {
      "type": "object",
      "required": ["voucherCode", "serviceName", "status", "result", "inspector", "inspectionDate", "appointmentDate", "completedDate", "plate", "renavam", "model", "year", "observacoes"],
      "properties": {
        "voucherCode": {"type": "string", "label": "Código do Voucher", "description": "Código associado ao voucher", "placeholder": "Ex: 08013"},
        "serviceName": {"type": "string", "label": "Nome do Serviço", "description": "Nome do serviço solicitado", "placeholder": "Ex: Vistoria Veicular – Credenciada"},
        "status": {"type": "string", "label": "Status", "description": "Status do pedido (scheduled, completed, etc.)", "placeholder": "Ex: scheduled"},
        "result": {"type": "string", "label": "Resultado", "description": "Resultado da inspeção (Aprovado, etc.)", "placeholder": "Ex: Aprovado"},
        "inspector": {"type": "string", "label": "Inspetor", "description": "Nome do inspetor responsável", "placeholder": "Ex: Carlos Silva"},
        "inspectionDate": {"type": "date", "label": "Data da Inspeção", "description": "Data da inspeção no formato ISO 8601 (YYYY-MM-DD)", "placeholder": "dd/mm/aaaa"},
        "appointmentDate": {"type": "date", "label": "Data do Agendamento", "description": "Data do agendamento no formato ISO 8601 (YYYY-MM-DD)", "placeholder": "dd/mm/aaaa"},
        "completedDate": {"type": "date", "label": "Data de Conclusão", "description": "Data de conclusão no formato ISO 8601 (YYYY-MM-DD)", "placeholder": "dd/mm/aaaa"},
        "plate": {"type": "string", "label": "Placa", "description": "Placa do veículo no padrão Mercosul (AAA1A23)", "pattern": "^[A-Z]{3}[0-9][A-Z][0-9]{2}", "placeholder": "Ex: BRA2E19"},
        "renavam": {"type": "string", "label": "RENAVAM", "description": "Registro Nacional do Veículo (9 a 11 dígitos)", "placeholder": "Ex: 123456789"},
        "model": {"type": "string", "label": "Marca/modelo", "description": "Marca e modelo do veículo", "placeholder": "Ex: Chevrolet Corsa"},
        "year": {"type": "string", "label": "Ano de fabricação", "description": "Ano de fabricação do veículo", "placeholder": "Ex: 2019"},
        "observacoes": {"type": "string", "label": "Observações", "description": "Observações sobre o pedido (até 1000 caracteres)", "placeholder": "Observações sobre o pedido"}
      }
    };
  }

  // Convert ServiceFormField into schema property (shared with other screens)
  static Map<String, dynamic> _fieldToSchema(ServiceFormField f) {
    final Map<String, dynamic> schema = {
      'type': f.type,
      'label': f.label,
      'description': '',
      'placeholder': f.label,
    };
    if (f.options != null && f.options!.isNotEmpty) schema['options'] = f.options;
    if (f.validationKey != null) schema['validationKey'] = f.validationKey;
    return schema;
  }

  Widget _buildDynamicForm(Map<String, dynamic> formSchema, VouchersStore store, BuildContext context, {GlobalKey<DynamicFormState>? formKey}) {
    return DynamicForm(
      key: formKey,
      formSchema: formSchema,
      store: store,
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = GetIt.instance<VouchersStore>();
  final dynamicFormKey = GlobalKey<DynamicFormState>();
    final providerStore = GetIt.instance<ProviderRequestStore>();
    ProviderRequest? providerRequestObj;
    try {
      providerRequestObj = providerStore.providerRequests.firstWhere((r) => r.id == providerRequestId);
    } catch (_) {
      providerRequestObj = null;
    }
  return Scaffold(
      appBar: const NavHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Builder(builder: (ctx) {
                final availableHeight = MediaQuery.of(ctx).size.height - 220; // leave room for header/margins
                // prepare a single future so both sides can reuse the fetched form
                final formFuture = ServicesService.instance.getServiceFormModel(formId: providerRequestObj?.formId ?? '');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Body header: back button, title and QR button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              context.router.replace(const MyVouchersRoute());
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: DsText(text: 'Formulário do Pedido do Provedor', variant: DsTextVariant.titleVoucher)),
                        OutlinedButton(
                          onPressed: () {
                            final svcId = providerRequestObj?.serviceId ?? providerRequestObj?.voucherServiceId ?? '';
                            providerStore.setSelected(providerRequestId: providerRequestId, serviceId: svcId);
                            context.router.push(ProviderRequestQRCodeRoute(providerRequestId: providerRequestId, serviceId: svcId, administratorId: administratorId));
                          },
                          child: const DsText(text: 'Ver QR Code', variant: DsTextVariant.small),
                        ),
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
                                DsText(text: providerRequestObj?.service?.name ?? providerRequestObj?.serviceName ?? '', variant: DsTextVariant.subTitleVoucher),
                                const SizedBox(height: 12),
                                DsText(text: 'Código do Serviço: ${providerRequestObj?.serviceId ?? providerRequestObj?.voucherServiceId ?? ''}', variant: DsTextVariant.small),
                                const SizedBox(height: 8),
                                DsText(text: 'Voucher nº: ${providerRequestObj?.voucherId ?? ''}', variant: DsTextVariant.small),
                                const SizedBox(height: 12),
                                            FutureBuilder<ValueResult<ServiceForm>>(
                                              future: formFuture,
                                              builder: (ctx, snap) {
                                                if (snap.connectionState != ConnectionState.done) {
                                                  return DsText(text: 'Carregando descrição...', variant: DsTextVariant.small);
                                                }
                                                final res = snap.data;
                                                if (res == null || res.isError || res.value == null) {
                                                  return DsText(text: providerRequestObj?.service?.description ?? providerRequestObj?.observacoes ?? '', variant: DsTextVariant.small);
                                                }
                                                final model = res.value!;
                                                return DsText(text: model.description ?? providerRequestObj?.service?.description ?? providerRequestObj?.observacoes ?? '', variant: DsTextVariant.small);
                                              },
                                            ),
                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Validate the right-side dynamic form using its GlobalKey
                                    final payload = dynamicFormKey.currentState?.validateAndCollect();
                                    if (payload == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Preencha os campos obrigatórios do formulário.')),
                                      );
                                      return;
                                    }
                                    final voucherId = '';

                                    final providerSelectedId = '';

                                    // Open confirmation modal and pass the collected payload
                                    showConfirmVoucherModal(context, store, providerRequestObj?.serviceId ?? providerRequestObj?.voucherServiceId ?? '', administratorId, voucherId, providerSelectedId, payload: payload);
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: const DsText(text: 'Confirmar agendamento', variant: DsTextVariant.baseBold, color: Colors.white),
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    } else {
                                      context.router.replace(const MyVouchersRoute());
                                    }
                                  },
                                  child: const DsText(text: 'Cancelar agendamento', variant: DsTextVariant.small, color: Colors.red),
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
                                if (snapshot.connectionState != ConnectionState.done) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  final fallback = _getFallbackSchemaForProviderRequest(providerRequestId);
                                  return SingleChildScrollView(child: _buildDynamicForm(fallback!, store, context));
                                }
                                final result = snapshot.data;
                                if (result == null || result.isError) {
                                  final fallback = _getFallbackSchemaForProviderRequest(providerRequestId);
                                  return SingleChildScrollView(child: _buildDynamicForm(fallback!, store, context));
                                }
                                final model = result.value;
                                if (model == null) {
                                  final fallback = _getFallbackSchemaForProviderRequest(providerRequestId);
                                  return SingleChildScrollView(child: _buildDynamicForm(fallback!, store, context));
                                }

                                final Map<String, dynamic> schema = {
                                  'type': 'object',
                                  'title': model.title,
                                  'description': model.description ?? '',
                                  'required': model.fields.where((f) => f.isRequired).map((f) => f.id).toList(),
                                  'properties': {
                                    for (final f in model.fields) f.id: _fieldToSchema(f),
                                  }
                                };

                                return SingleChildScrollView(child: _buildDynamicForm(schema, store, context, formKey: dynamicFormKey));
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
}
