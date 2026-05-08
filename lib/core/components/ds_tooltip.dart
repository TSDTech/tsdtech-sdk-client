import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DsTooltip extends StatefulWidget {
  const DsTooltip({
    super.key,
    required this.message,
    this.size = 15,
    this.borderColor,
    this.iconColor,
    this.circleFillColor,
    this.tooltipBgColor,
    this.maxWidth = 280,
  });

  final String message;
  final double size;
  final Color? borderColor; // azul (borda do círculo)
  final Color? iconColor; // azul (letra "i")
  final Color? circleFillColor; // branco (fundo do círculo)
  final Color? tooltipBgColor; // branco (fundo do popup)
  final double maxWidth;

  @override
  State<DsTooltip> createState() => _DsTooltipState();
}

class _DsTooltipState extends State<DsTooltip> {
  final LayerLink _link = LayerLink();
  final GlobalKey _targetKey = GlobalKey();
  OverlayEntry? _entry;

  // Parâmetros calculados a cada "show"
  bool _openToLeft = false; // abre para esquerda?
  bool _openAbove = false; // abre para cima?
  double _maxWidthThisShow = 280;
  double _maxHeightThisShow = 400;

  static const double _gap = 8; // distância entre alvo e tooltip
  static const double _margin = 8; // margem até as bordas da tela

  Color get _blue =>
      widget.borderColor ??
      widget.iconColor ??
      const Color.fromRGBO(0, 64, 128, 1);

  void _computePlacement() {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final pad = mq.padding;

    final safeLeft = pad.left + _margin;
    final safeRight = size.width - pad.right - _margin;
    final safeTop = pad.top + _margin;
    final safeBottom = size.height - pad.bottom - _margin;

    final box = _targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      // fallback conservador
      _openToLeft = false;
      _openAbove = false;
      _maxWidthThisShow = widget.maxWidth;
      _maxHeightThisShow = size.height / 3;
      return;
    }

    final targetSize = box.size;
    final targetTopLeft = box.localToGlobal(Offset.zero);
    final tLeft = targetTopLeft.dx;
    final tTop = targetTopLeft.dy;
    final tRight = tLeft + targetSize.width;
    final tBottom = tTop + targetSize.height;

    // Espaço útil disponível
    final spaceRight = math.max(0, safeRight - tLeft); // abrindo p/ direita
    final spaceLeft = math.max(0, tRight - safeLeft); // abrindo p/ esquerda
    final spaceBelow = math.max(0, safeBottom - tBottom);
    final spaceAbove = math.max(0, tTop - safeTop);

    // Decide horizontal (prioriza o lado com mais espaço)
    _openToLeft = spaceLeft > spaceRight;

    // Decide vertical (prioriza onde há mais espaço)
    _openAbove = spaceAbove > spaceBelow;

    // Largura/altura máximas garantidamente dentro da tela
    double horizAvail = (_openToLeft ? spaceLeft : spaceRight).toDouble();
    double vertAvail = (_openAbove ? spaceAbove : spaceBelow).toDouble();

    // Nunca excede o maxWidth desejado e respeita mínimo usável
    _maxWidthThisShow = math.max(120, math.min(widget.maxWidth, horizAvail));
    _maxHeightThisShow = math.max(60, vertAvail);
  }

  TextSpan _parseMarkdown(String text, TextStyle base) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*(.*?)\*');
    int start = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(
            TextSpan(text: text.substring(start, match.start), style: base));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: base.copyWith(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: base));
    }

    return TextSpan(children: spans, style: base);
  }

  void _show({required bool withBarrier}) {
    if (_entry != null) return;

    _computePlacement();

    _entry = OverlayEntry(
      builder: (context) {
        final bg = widget.tooltipBgColor ?? Colors.white;

        // Anchors conforme decisões acima
        final bool left =
            !_openToLeft; // "abre para direita" => ancora na ESQUERDA do target
        final bool below = !_openAbove;

        Alignment targetAnchor;
        Alignment followerAnchor;
        Offset offset;

        if (below && left) {
          targetAnchor = Alignment.bottomLeft;
          followerAnchor = Alignment.topLeft;
          offset = const Offset(0, _gap);
        } else if (below && !left) {
          targetAnchor = Alignment.bottomRight;
          followerAnchor = Alignment.topRight;
          offset = const Offset(0, _gap);
        } else if (!below && left) {
          targetAnchor = Alignment.topLeft;
          followerAnchor = Alignment.bottomLeft;
          offset = const Offset(0, -_gap);
        } else {
          targetAnchor = Alignment.topRight;
          followerAnchor = Alignment.bottomRight;
          offset = const Offset(0, -_gap);
        }

        return Stack(children: [
          if (withBarrier)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hide,
                child: const SizedBox.shrink(),
              ),
            ),
          CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: offset,
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // Garante que não passa da borda
                  maxWidth: _maxWidthThisShow,
                  maxHeight: _maxHeightThisShow,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(blurRadius: 10, color: Colors.black26)
                    ],
                    border: Border.all(color: _blue.withOpacity(.12)),
                  ),
                  child: DefaultTextStyle(
                    style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.black87) ??
                        const TextStyle(color: Colors.black87),
                    child: SingleChildScrollView(
                      // Se o conteúdo for maior que a altura disponível, rola.
                      child: Text.rich(
                        _parseMarkdown(
                            widget.message,
                            Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black87) ??
                                const TextStyle(color: Colors.black87)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  bool get _isDesktopLike {
    final p = defaultTargetPlatform;
    return kIsWeb ||
        p == TargetPlatform.macOS ||
        p == TargetPlatform.windows ||
        p == TargetPlatform.linux;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fill = widget.circleFillColor ?? Colors.white;
    final blue = _blue;
    final icon = widget.iconColor ?? blue;

    final circle = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: Border.all(color: blue),
      ),
      alignment: Alignment.center,
      child: Text(
        'i',
        style: TextStyle(
          color: icon,
          fontWeight: FontWeight.w700,
          fontSize: widget.size * 0.7,
          height: 1.0,
        ),
      ),
    );

    // Colocamos a key num wrapper "físico" para medir com precisão
    final target = CompositedTransformTarget(
      link: _link,
      child: SizedBox(
        key: _targetKey,
        width: widget.size,
        height: widget.size,
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          child: Semantics(
            button: true,
            label: 'Informação',
            hint: 'Mostra mais detalhes',
            child: circle,
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: _isDesktopLike ? (_) => _show(withBarrier: false) : null,
      onExit: _isDesktopLike ? (_) => _hide() : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (_entry == null) {
            _show(withBarrier: true);
          } else {
            _hide();
          }
        },
        child: target,
      ),
    );
  }
}
