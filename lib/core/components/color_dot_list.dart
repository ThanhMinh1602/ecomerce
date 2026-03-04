import 'package:flutter/material.dart';

class ColorDotList extends StatelessWidget {
  final List<String> colors;
  final double size;
  final double spacing;
  final int limit;

  const ColorDotList({
    super.key,
    required this.colors,
    this.size = 18.0,
    this.spacing = 6.0,
    this.limit = 4,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: 4.0,
      children: colors.take(limit).map((colorHex) {
        return _buildColorItem(colorHex);
      }).toList(),
    );
  }

  Widget _buildColorItem(String colorHex) {
    Color color;
    try {
      color = Color(int.parse(colorHex));
    } catch (e) {
      color = Colors.grey;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,

        border: Border.all(color: Colors.black.withOpacity(0.1), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
