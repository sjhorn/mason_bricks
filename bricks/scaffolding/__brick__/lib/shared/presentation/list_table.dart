import 'package:flutter/material.dart';

class ListTable<T> extends StatelessWidget {
  final int totalCount;
  final int cacheCount;
  final List<String> columns;
  final List<T> cache;
  final List<Widget> Function(T entity) renderRow;
  final Future Function() readMore;
  final Function(T entity) edit;

  const ListTable({
    Key? key,
    required this.totalCount,
    required this.cacheCount,
    required this.columns,
    required this.cache,
    required this.renderRow,
    required this.readMore,
    required this.edit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(0), children: [
      PaginatedDataTable(
        showCheckboxColumn: false,
        rowsPerPage: 10,
        columns: columns.map((e) => DataColumn(label: Text(e))).toList(),
        source: _DataSource(
          rowCount: cacheCount == totalCount ? totalCount : cacheCount + 1,
          rowBuilder: (index) {
            if (index == cacheCount) {
              Future.delayed(Duration.zero, readMore);
              return DataRow(cells: [
                const DataCell(CircularProgressIndicator()),
                ...List.filled(columns.length - 1, DataCell(Container())),
              ]);
            } else {
              var entity = cache[index];
              int cell = 0;
              return DataRow(
                key: ObjectKey(entity),
                onSelectChanged: (value) => edit(entity),
                cells: renderRow(entity).map((e) {
                  return cell++ == 0
                      ? DataCell(Container(key: ObjectKey(entity), child: e))
                      : DataCell(e);
                }).toList(),
              );
            }
          },
        ),
      )
    ]);
  }
}

class _DataSource extends DataTableSource {
  final DataRow? Function(int index) rowBuilder;

  @override
  final int rowCount;

  _DataSource({required this.rowBuilder, required this.rowCount});

  @override
  DataRow? getRow(int index) => rowBuilder(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => -1;
}
