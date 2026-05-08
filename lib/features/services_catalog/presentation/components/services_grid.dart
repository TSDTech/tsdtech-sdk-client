import 'package:flutter/material.dart';
import 'package:voucherize/features/services_catalog/presentation/components/service_card.dart';
import 'package:voucherize/models/services/service.model.dart';

class ServicesGrid extends StatelessWidget {
  final List<Service> services;

  const ServicesGrid({required this.services, super.key});

  @override
  Widget build(BuildContext context) {
    final cross = MediaQuery.of(context).size.width > 1200 ? 3 : MediaQuery.of(context).size.width > 800 ? 2 : 1;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (_, idx) {
        final s = services[idx];
  final priceText = (s.price != null) ? 'R\$ ${s.price!.toStringAsFixed(2)}' : '';
  final tags = <String>[];
  if (s.serviceType?.name != null) tags.add(s.serviceType!.name!);
  if (s.tags != null && s.tags!.isNotEmpty) tags.addAll(s.tags!);

        return ServiceCard(
          title: s.name ?? '',
          code: s.code ?? '',
          description: s.description ?? '',
          price: priceText,
          tags: tags,
          service: s,
          onAdd: () {},
        );
      },
    );
  }
}
