import 'package:flutter/material.dart';

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
  // 1. Khai báo ScrollController để điều khiển thanh cuộn ngang
  // Việc dùng chung controller cho Scrollbar và SingleChildScrollView giúp sửa lỗi trên Web
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    // 2. Giải phóng controller khi widget bị hủy để tránh rò rỉ bộ nhớ
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
    if (widget.isLoading) return _buildLoadingState();
    if (widget.items.isEmpty) return widget.emptyWidget ?? _buildEmptyState();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          // 3. Gán controller cho Scrollbar
          controller: _horizontalController,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 8,
          radius: const Radius.circular(4),
          child: SingleChildScrollView(
            // 4. Gán CÙNG controller cho SingleChildScrollView
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

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(60.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 3, color: Colors.blueAccent),
            SizedBox(height: 16),
            Text("Đang tải dữ liệu...", style: TextStyle(color: Colors.grey)),
          ],
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
