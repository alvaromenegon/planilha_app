import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planilla_android/app/core/classes/json_object.dart';
import 'package:planilla_android/app/core/ui/styles/colors_app.dart';
import 'package:planilla_android/app/core/ui/styles/text_styles.dart';
import 'package:planilla_android/app/core/ui/theme/theme_config.dart';

/// <code>data</code> deve ser um tipo de dado que implementa <code>JsonObject</code>
/// ou que tenha um método <code>toJson()</code> que retorne um
/// ```dart
/// Map<String, dynamic>
/// ```
class Tabela extends StatelessWidget {
  final List<dynamic> data;
  final List<String> headers;
  final bool showIndex;
  static var defaultBorderColor = ColorsApp.instance.primary;

  const Tabela({
    super.key, 
    required this.data, 
    required this.headers,
    this.showIndex = false,
    });

  @override
  Widget build(BuildContext context) {
    final BorderSide border =
        ThemeConfig.defaultBorder["borderSide"] as BorderSide;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: TextStyles.instance.outlinePrimaryButtonLabel,
        border: TableBorder(
            horizontalInside: border,
            verticalInside: border,
            top: border,
            bottom: border,
            left: border,
            right: border,
            borderRadius: ThemeConfig.defaultBorderRadius),
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  /// Retorna uma string que representa o valor da célula
  ///
  /// Se o valor for nulo, retorna uma string vazia
  ///
  /// Se o valor for um [Timestamp], retorna a data formatada
  ///
  /// Caso contrário, retorna o valor convertido para string
  String _showText(dynamic cell) {
    if (cell == null) {
      return '';
    }
    if (cell is Timestamp) {
      return cell.toDate().toString();
    }
    if (cell is double) {
      return cell.toStringAsFixed(2);
    }
    return cell.toString();
  }

  List<DataColumn> _buildColumns() {
    // Defina as colunas da tabela aqui
    if (showIndex) {
      return [
        const DataColumn(label: Text('#')),
        ...headers.map((header) => DataColumn(label: Text(header)))
      ];
    }
    return headers.map((header) => DataColumn(label: Text(header))).toList();
  }

  List<DataRow> _buildRows() {
    // Preencha as linhas da tabela com os dados fornecidos
    return data.map((row) {
      Map<String, dynamic> jsonRow = {};
      // Convert the object to a Map<String, dynamic>
      // if it is a JsonObject or a Map<String,dynamic>
      // otherwise throw an exception
      if (row is JsonObject) {
        jsonRow = row.toJson();
      } else if (row is Map<String, dynamic>) {
        jsonRow = row;
      } else {
        throw Exception('Data must be a JsonObject or a Map<String,dynamic>');
      }

      if (showIndex) {
        return DataRow(
            cells: [
              DataCell(Text('${data.indexOf(row)+1}')),
              ...jsonRow.values
                  .map((cell) => DataCell(Text(_showText(cell))))
                  .toList()
                  .cast<DataCell>()
            ].toList());
      }

      return DataRow(
          cells: jsonRow.values
              .map((cell) => DataCell(Text(_showText(cell))))
              .toList()
              .cast<DataCell>());
    }).toList();
  }
}
