import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomAdminTable<T> extends StatefulWidget {
  final List<String> columns;
  final List<T> items;
  final DataRow Function(T item, int index) rowBuilder;
  final bool isLoading;
  final Widget? emptyWidget;
  final double? minWidth;
  final int rowsPerPage; 

  const CustomAdminTable({
    super.key,
    required this.columns,
    required this.items,
    required this.rowBuilder,
    this.isLoading = false,
    this.emptyWidget,
    this.minWidth,
    this.rowsPerPage = 6, 
  });

  @override
  State<CustomAdminTable<T>> createState() => _CustomAdminTableState<T>();
}

class _CustomAdminTableState<T> extends State<CustomAdminTable<T>> {
  final ScrollController _horizontalController = ScrollController();
  int _currentPage = 0; 

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  
  
  @override
  void didUpdateWidget(covariant CustomAdminTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      int maxPage = (widget.items.length - 1) ~/ widget.rowsPerPage;
      if (_currentPage > maxPage) {
        _currentPage = maxPage >= 0 ? maxPage : 0;
      }
    }
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
      child: Column(
        children: [
          Expanded(child: _buildBody(context)),
          
          if (!widget.isLoading && widget.items.isNotEmpty) _buildPaginationFooter(),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (widget.isLoading) return _buildShimmerLoading(context);
    if (widget.items.isEmpty) return widget.emptyWidget ?? _buildEmptyState();

    
    final int startIndex = _currentPage * widget.rowsPerPage;
    final int endIndex = (startIndex + widget.rowsPerPage) > widget.items.length
        ? widget.items.length
        : (startIndex + widget.rowsPerPage);

    final List<T> pagedItems = widget.items.sublist(startIndex, endIndex);

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
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                  dataRowMinHeight: 65,
                  dataRowMaxHeight: 85,
                  headingRowHeight: 52,
                  horizontalMargin: 24,
                  columnSpacing: 24,
                  showCheckboxColumn: false,
                  columns: widget.columns.map((name) => _buildColumn(name)).toList(),
                  rows: List.generate(
                    pagedItems.length,
                        (index) => widget.rowBuilder(pagedItems[index], startIndex + index),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  

  Widget _buildPaginationFooter() {
    final int totalPages = (widget.items.length / widget.rowsPerPage).ceil();
    final int startEntry = (_currentPage * widget.rowsPerPage) + 1;
    final int endEntry = ((_currentPage + 1) * widget.rowsPerPage) > widget.items.length
        ? widget.items.length
        : (_currentPage + 1) * widget.rowsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hiển thị $startEntry đến $endEntry trong tổng số ${widget.items.length} bản ghi",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          Row(
            children: [
              _buildPageButton(
                icon: Icons.chevron_left,
                onTap: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${_currentPage + 1} / $totalPages",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              _buildPageButton(
                icon: Icons.chevron_right,
                onTap: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: onTap == null ? Colors.transparent : Colors.white,
          border: Border.all(color: onTap == null ? Colors.transparent : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: onTap == null ? Colors.grey[300] : Colors.grey[700],
          size: 18,
        ),
      ),
    );
  }

  

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(height: 52, color: Colors.white, margin: const EdgeInsets.only(bottom: 2)),
          ...List.generate(6, (index) => _buildShimmerRow()),
        ],
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade50))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.columns.length,
              (index) => Expanded(
            child: Container(
              height: 20,
              margin: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
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
              decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
              child: Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            const Text("Dữ liệu đang trống", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3F4254), fontSize: 16)),
            const SizedBox(height: 4),
            Text("Hệ thống chưa ghi nhận bản ghi nào tại đây.", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      ),
    );
  }
}