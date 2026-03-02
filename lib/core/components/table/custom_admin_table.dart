import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Thêm import này

class CustomAdminTable<T> extends StatefulWidget {
  final List<String> columns;
  final List<T> items;
  final DataRow Function(T item, int index) rowBuilder;
  final bool isLoading;
  final Widget? emptyWidget;
  final double? minWidth;

  const CustomAdminTable({
    super.key,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    this.isLoading = false,
    this.emptyWidget,
    this.minWidth,
  });

  @override
  State<CustomAdminTable<T>> createState() => _CustomAdminTableState<T>();
}

class _CustomAdminTableState<T> extends State<CustomAdminTable<T>> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Nếu đang load, sử dụng Shimmer thay vì CircularProgress [cite: 2026-02-28]
    if (widget.isLoading) return _buildShimmerLoading(context);

    if (widget.items.isEmpty) return widget.emptyWidget ?? _buildEmptyState();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 8,
          radius: const Radius.circular(4),
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: widget.minWidth ?? constraints.maxWidth,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.grey.shade50,
                  dataTableTheme: DataTableThemeData(
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E6278),
                      fontSize: 13,
                    ),
                  ),
                ),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFFF9FAFB),
                  ),
                  dataRowMinHeight: 65,
                  dataRowMaxHeight: 80,
                  headingRowHeight: 52,
                  horizontalMargin: 24,
                  columnSpacing: 24,
                  showCheckboxColumn: false,
                  columns: widget.columns
                      .map((name) => _buildColumn(name))
                      .toList(),
                  rows: List.generate(
                    widget.items.length,
                    (index) => widget.rowBuilder(widget.items[index], index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Hiệu ứng Shimmer Loading cho toàn bộ bảng
  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            // Giả lập Heading của bảng
            Container(
              height: 52,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 2),
            ),
            // Giả lập 6 dòng dữ liệu [cite: 2026-02-28]
            ...List.generate(6, (index) => _buildShimmerRow()),
          ],
        ),
      ),
    );
  }

  /// Widget dòng Shimmer đơn lẻ để khớp với cấu trúc DataRow
  Widget _buildShimmerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.columns.length,
          (index) => Expanded(
            child: Container(
              height: 20,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildColumn(String name) {
    return DataColumn(
      label: Text(
        name.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Color(0xFF808291),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Dữ liệu đang trống",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F4254),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Hệ thống chưa ghi nhận bản ghi nào tại đây.",
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
