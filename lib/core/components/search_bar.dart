import 'package:flutter/material.dart';

class CategoryOption {
  final String name;
  final int count;
  bool isSelected;

  CategoryOption({
    required this.name,
    required this.count,
    this.isSelected = false,
  });
}

class TransactionSearchBar extends StatefulWidget {
  const TransactionSearchBar({
    super.key,
    this.onSearchChanged,
    this.onCategoryTap,
    this.searchController,
    this.hintText = 'Buscar transação',
    this.categories = const [],
  });

  final Function(String)? onSearchChanged;
  final VoidCallback? onCategoryTap;
  final TextEditingController? searchController;
  final String hintText;
  final List<CategoryOption> categories;

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late List<CategoryOption> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
  }

  void _hideCategoryDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de pesquisa
            Row(
              children: [
                // Campo de busca
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.5,
                      ),
                    ),
                    child: TextField(
                      controller: widget.searchController,
                      onChanged: widget.onSearchChanged,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0F172A),
                        fontFamily: 'Open Sans',
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1F2937),
                          fontFamily: 'Open Sans',
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF1F2937),
                          size: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 12),
                // // Botão de categoria
                // MouseRegion(
                //   cursor: SystemMouseCursors.click,
                //   child: GestureDetector(
                //     onTap: () {
                //       if (_overlayEntry == null) {
                //         _showCategoryDropdown();
                //       } else {
                //         _hideCategoryDropdown();
                //       }
                //     },
                //     child: Container(
                //       height: 48,
                //       padding: const EdgeInsets.symmetric(horizontal: 16),
                //       decoration: BoxDecoration(
                //         color: const Color(0xFFF8F9FA),
                //         borderRadius: BorderRadius.circular(12),
                //         border: Border.all(
                //           color: const Color(0xFFE2E8F0),
                //           width: 1,
                //         ),
                //       ),
                //       child: const Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Icon(
                //             Icons.tune,
                //             color: Color(0xFF64748B),
                //             size: 20,
                //           ),
                //           SizedBox(width: 8),
                //           Text(
                //             'Categoria',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.w400,
                //               color: Color(0xFF64748B),
                //               fontFamily: 'Open Sans',
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            // Chips das categorias selecionadas
            if (_categories.any((category) => category.isSelected))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _categories
                      .where((category) => category.isSelected)
                      .map((category) => _buildCategoryChip(category))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(CategoryOption category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F172A),
              fontFamily: 'Open Sans',
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  category.isSelected = false;
                });
              },
              child: const Icon(
                Icons.close,
                size: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideCategoryDropdown();
    super.dispose();
  }
}
