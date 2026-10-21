import 'dart:async';

import 'package:app/core/widgets/button.dart';
import 'package:app/core/widgets/extensions.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class PaginatedTableComponent<T extends Object> extends StatefulWidget {
  const PaginatedTableComponent({
    required this.columns,
    required this.data,
    this.rowHeight,
    this.selectable = false,
    this.onSelect,
    this.selected,
    this.hasFlexibleRowHeight = false,
    this.searchText = 'Filter',
    this.showSearchField = true,
    this.rowsPerPage = 10,
    this.onSearch,
    this.onLongPress,
    this.onTap,
    this.addDataButton,
    super.key,
  });

  final List<TableColumn<T>> columns;
  final List<T> data;
  final double? rowHeight;
  final bool selectable;
  final Function(T)? onSelect;
  final List<T>? selected;
  final bool hasFlexibleRowHeight;
  final String searchText;
  final bool showSearchField;
  final int rowsPerPage;
  final bool Function(T, String)? onSearch;
  final void Function(T)? onLongPress;
  final void Function(T)?
  onTap; // Called when use taps on table row, parameter is current row data T
  final Button? addDataButton; // Optional button used to add items to table.

  @override
  State<PaginatedTableComponent<T>> createState() =>
      _PaginatedTableComponentState<T>();
}

class _PaginatedTableComponentState<T extends Object>
    extends State<PaginatedTableComponent<T>> {
  late TextEditingController textEditingController;
  late List<T> filteredData;
  Timer? debounce;
  int? hoveredRowIndex;
  int currentPage = 0;
  String searchQuery = '';
  int rowsPerPage = 10;
  int? sortColumnIndex;
  bool isAscending = true;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    filteredData = widget.data;
    rowsPerPage = widget.rowsPerPage;
  }

  @override
  void didUpdateWidget(covariant PaginatedTableComponent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!DeepCollectionEquality().equals(oldWidget.data, widget.data)) {
      onSearchTextChanged(textEditingController.text);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    debounce?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void sortByColumn(int columnIndex, [bool resort = false]) {
    final TableColumn<T> column = widget.columns[columnIndex];

    if (!column.enableColumnSorting || column.onSort == null) return;

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = resort ? isAscending : !isAscending;
      filteredData.sort((a, b) {
        return isAscending ? column.onSort!(a, b) : column.onSort!(b, a);
      });
    });
  }

  bool onSearch(T data, String query) {
    if (widget.onSearch != null) {
      return widget.onSearch!(data, query);
    }

    return data.toString().toLowerCase().contains(query);
  }

  void onSearchTextChanged(String? value) {
    value = value?.trim();

    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 300), () {
      final String query = textEditingController.text.toLowerCase();

      setState(() {
        currentPage = 0;
        searchQuery = query;
        filteredData = widget.data.where((T data) {
          return onSearch(data, query);
        }).toList();
        if (sortColumnIndex != null) {
          sortByColumn(sortColumnIndex!, true);
        }
      });
    });
  }

  List<T> get paginatedData {
    final start = currentPage * rowsPerPage;
    final end = start + rowsPerPage;
    return filteredData.sublist(
      start,
      end > filteredData.length ? filteredData.length : end,
    );
  }

  List<int?> getDisplayedPages(int currentPage, int totalPages) {
    final List<int?> pages = [];

    // Always include the first page
    pages.add(1);

    if (totalPages <= 5) {
      // If few pages, just show them all
      for (int i = 2; i <= totalPages; i++) {
        pages.add(i);
      }
      return pages;
    }

    // First or second page (0-based index)
    if (currentPage <= 1) {
      pages.add(2);
      pages.add(3);
      pages.add(null);
      pages.add(totalPages);
    }
    // Last or second last page
    else if (currentPage >= totalPages - 2) {
      pages.add(null);
      pages.add(totalPages - 2);
      pages.add(totalPages - 1);
      pages.add(totalPages);
    }
    // Middle pages
    else {
      pages.add(null);
      pages.add(currentPage); // already 0-based
      pages.add(currentPage + 1);
      pages.add(currentPage + 2);
      pages.add(null);
      pages.add(totalPages);
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      alignment: Alignment.center,
      constraints: const BoxConstraints(minWidth: double.infinity),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.colors.onSurface.withValues(alpha: 0.1),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: <Widget>[
          if (widget.showSearchField || widget.addDataButton != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (widget.showSearchField)
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      controller: textEditingController,
                      onChanged: onSearchTextChanged,
                      decoration: InputDecoration(
                        hintText: widget.searchText,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.colors.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                if (widget.addDataButton != null)
                  Flexible(child: widget.addDataButton!),
              ],
            ),
            const SizedBox(height: 20),
          ],
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    // color: context.colors.onSurface.withValues(alpha: 0.1),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Scrollbar(
                  controller: scrollController,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  interactive: true,
                  trackVisibility: true,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: 10,
                        dividerThickness: 0,
                        dataRowMaxHeight: widget.hasFlexibleRowHeight
                            ? double.infinity
                            : widget.rowHeight,
                        checkboxHorizontalMargin: 0,
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: context.colors.onSurface.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        dataRowColor: WidgetStateProperty.all(
                          colorScheme.surface,
                        ),
                        headingRowColor: WidgetStateProperty.all(
                          context.colors.onSurface.withValues(alpha: 0.1),
                        ),
                        columns: <DataColumn>[
                          ...widget.columns.mapIndexed(
                            (index, column) => DataColumn(
                              label: Row(
                                children: <Widget>[
                                  Text(
                                    column.columnName,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                  if (column.enableColumnSorting)
                                    Icon(
                                      sortColumnIndex == index
                                          ? (isAscending
                                                ? Icons.arrow_upward
                                                : Icons.arrow_downward)
                                          : Icons.unfold_more,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                ],
                              ),
                              onSort: column.enableColumnSorting
                                  ? (index, _) => sortByColumn(index)
                                  : null,
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(paginatedData.length, (
                          int index,
                        ) {
                          final data = paginatedData[index];
                          return DataRow(
                            selected: widget.selected?.contains(index) ?? false,
                            onSelectChanged: widget.selectable
                                ? (bool? value) {
                                    if (widget.onSelect != null) {
                                      widget.onSelect!(data);
                                    }
                                  }
                                : null,
                            onLongPress: widget.onLongPress == null
                                ? null
                                : () => widget.onLongPress!(data),
                            color: WidgetStateProperty.all<Color?>(
                              hoveredRowIndex == index
                                  ? colorScheme.surface.withValues(alpha: 0.0)
                                  : colorScheme.surface.withValues(alpha: 0.3),
                            ),
                            cells: <DataCell>[
                              ...List<DataCell>.generate(
                                widget.columns.length,
                                (int i) {
                                  final column = widget.columns[i];
                                  return DataCell(
                                    onTap: widget.onTap == null
                                        ? null
                                        : () => widget.onTap!(data),
                                    MouseRegion(
                                      onEnter: (_) {
                                        setState(() {
                                          hoveredRowIndex = index;
                                        });
                                      },
                                      onExit: (_) {
                                        setState(() {
                                          hoveredRowIndex = null;
                                        });
                                      },
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 500,
                                          minWidth: 80,
                                        ),
                                        child: column.onBuild == null
                                            ? Text(data.toString())
                                            : column.onBuild!(data),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    'Showing ${paginatedData.length} of ${filteredData.length} rows',
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 0
                          ? () => setState(() => currentPage--)
                          : null,
                    ),
                    ...getDisplayedPages(
                      currentPage,
                      (filteredData.length / rowsPerPage).ceil(),
                    ).map<Widget>((page) {
                      if (page == null) {
                        return const PageButton(
                          pageNumber: '...',
                          isSelected: false,
                        );
                      } else {
                        final pageNumber = page;
                        final isSelected = pageNumber == currentPage + 1;
                        return PageButton(
                          pageNumber: pageNumber.toString(),
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              currentPage =
                                  pageNumber - 1; // Because index starts from 0
                            });
                          },
                        );
                      }
                    }),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed:
                          (currentPage + 1) * rowsPerPage < filteredData.length
                          ? () => setState(() => currentPage++)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageButton extends StatelessWidget {
  const PageButton({
    required this.pageNumber,
    super.key,
    this.isSelected = false,
    this.onTap,
  });
  final String pageNumber;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : Colors.transparent, // Selected page background
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          pageNumber,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface, // Selected page text color
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class TableColumn<T> {
  const TableColumn({
    this.onBuild,
    this.onSort,
    this.enableColumnSorting = false,
    required this.columnName,
  }) : assert((enableColumnSorting && onSort != null) || !enableColumnSorting);

  final Widget Function(T)? onBuild;
  final int Function(T, T)? onSort;
  final bool enableColumnSorting;
  final String columnName;
}
