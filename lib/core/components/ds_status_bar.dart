import 'package:flutter/material.dart';
import 'package:tsdtech_client_sdk/core/components/ds_text.dart';

class DsStatusBar extends StatefulWidget {
  final List<String> labels;
  final int currentIndex;
  final void Function(int)? onPressed;

  const DsStatusBar({
    super.key,
    required this.labels,
    required this.currentIndex,
    this.onPressed,
  });

  @override
  State<DsStatusBar> createState() => _DsStatusBarState();
}

class _DsStatusBarState extends State<DsStatusBar> {
  final _scrollController = ScrollController();

  static const itemWidth = 104.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  void _scrollToCurrent() {
    final targetOffset = (widget.currentIndex * itemWidth) - 24;

    if (_scrollController.hasClients) {
      final max = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        targetOffset.clamp(0, max),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(0, 64, 128, 1);
    const inactiveColor = Color(0xFF94A3B8);
    const progressBgColor = Color(0xFFF1F5F9);
    const backgroundColor = Color(0xFFF8FAFC); // cor de fundo (mesma da tela)

    final itemCount = widget.labels.length;
    final totalWidth = itemWidth * itemCount;

    return Container(
      width: double.infinity,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: totalWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(itemCount, (index) {
                      final isActive = index == widget.currentIndex;
                      final isCompleted = index < widget.currentIndex;
                      final dotColor = isActive || isCompleted
                          ? primaryColor
                          : inactiveColor;
                      final textColor = dotColor;

                      return SizedBox(
                        width: itemWidth,
                        child: GestureDetector(
                          onTap: widget.onPressed != null
                              ? () => widget.onPressed!(index)
                              : null,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: dotColor,
                                child: DsText(
                                  text: '${index + 1}',
                                  variant: DsTextVariant.statusBarNumber,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: DsText(
                                  text: widget.labels[index],
                                  variant: DsTextVariant.statusBar,
                                  color: textColor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        width: totalWidth,
                        decoration: BoxDecoration(
                          color: progressBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: (widget.currentIndex + 0.5) * itemWidth,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
