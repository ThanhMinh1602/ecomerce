import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';

class ColorDotList extends StatelessWidget {
  final List<String> colors;
  final double size;
  final double spacing;

  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const ColorDotList({
    super.key,
    required this.colors,
    this.size = 18.0,
    this.spacing = 4.0,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: spacing,
      runSpacing: 4.0,
      children: colors.map((colorHex) {
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

    bool isSelected = colorHex == selectedColor;

    return GestureDetector(
      onTap: () => onColorSelected(colorHex),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: AppColor.orange500, width: 1.5)
              : null,
        ),
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
