import 'package:flutter/material.dart';

class NavigationBarItem {
  final String label;
  final IconData icon;
  final Color color;

  const NavigationBarItem({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({
    Key? key,
    required this.items,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(16.0),
    this.itemPadding = const EdgeInsets.all(16.0),
    this.itemSpacing = 16.0,
    this.itemIconSize = 24.0,
  }) : super(key: key);

  final List<NavigationBarItem> items;
  final Color backgroundColor;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final double itemSpacing;
  final double itemIconSize;

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: widget.backgroundColor,
      padding: widget.padding.add(EdgeInsets.only(bottom: bottomPadding)),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final maxWidth = constraints.maxWidth;
          final totalItemsIconWidth =
              (widget.itemIconSize + widget.itemPadding.horizontal) * (widget.items.length - 1);
          final totalItemsSpacingWidth = widget.itemSpacing * (widget.items.length - 1);
          final itemMaxWidth = maxWidth - totalItemsIconWidth - totalItemsSpacingWidth;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              widget.items.length,
              (i) => ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromWidth(itemMaxWidth)),
                child: _NavigationItem(
                  item: widget.items[i],
                  backgroundColor: widget.backgroundColor,
                  iconSize: widget.itemIconSize,
                  padding: widget.itemPadding,
                  current: i == _currentIndex,
                  onTap: () => setState(() => _currentIndex = i),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationItem extends StatefulWidget {
  const _NavigationItem({
    Key? key,
    required this.item,
    required this.backgroundColor,
    required this.iconSize,
    required this.padding,
    required this.current,
    required this.onTap,
  }) : super(key: key);

  final NavigationBarItem item;
  final Color backgroundColor;
  final double iconSize;
  final EdgeInsets padding;
  final bool current;
  final void Function() onTap;

  @override
  __NavigationItemState createState() => __NavigationItemState();
}

class __NavigationItemState extends State<_NavigationItem> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _backgroundAnimation;
  late final Animation<Color?> _foregroundAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: (widget.current) ? 1.0 : 0.0,
    );

    _backgroundAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.item.color.withOpacity(0.25),
    ).animate(_controller);
    _foregroundAnimation = ColorTween(
      begin: Colors.black54,
      end: widget.item.color,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NavigationItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.current != oldWidget.current) {
      if (widget.current)
        _controller.forward();
      else
        _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LayoutBuilder(
        builder: (_, constraints) {
          final iconSize = widget.iconSize;
          final padding = widget.padding;
          final totalIconWidth = iconSize + padding.horizontal;
          final totalIconHeight = iconSize + padding.vertical;
          final labelWidth = constraints.maxWidth - totalIconWidth;

          return AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => DecoratedBox(
              decoration: BoxDecoration(
                color: _backgroundAnimation.value,
                borderRadius: BorderRadius.circular(totalIconHeight * 0.5),
              ),
              child: Padding(
                padding: padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.item.icon,
                      color: _foregroundAnimation.value,
                      size: iconSize,
                    ),
                    ClipRect(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tight(
                          Size(labelWidth * _controller.value, iconSize - 4.0),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: padding.right),
                            child: Text(
                              widget.item.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _foregroundAnimation.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      onTap: widget.onTap,
    );
  }
}
